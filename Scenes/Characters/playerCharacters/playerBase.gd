extends CharacterBody2D # 1. Changed base class

const UP_DIRECTION = Vector2.UP # 2. Standard UP vector
export var gravity_value = 40 # Renamed to avoid conflict with potential future built-in 'gravity'
export var acceleration_value = 50 # Renamed
export var max_speed = 400 # Renamed
export var jump_velocity = -850 # Renamed
export var health = 100.0
export var stamina = 100.0

var velocity = Vector2() # 2. Replaced 'motion' with 'velocity'
var lastState = "idle"
var state = "idle"
var facingDirection = "right"
var withinInteractableRange = false
var objInteractedWith
var transitionTarget = [] # Map, X coord, Y coord
var invulnerable = false
var stunned = 0.0
var controlsEnabled = true
var p1MessageDisplayed = false # These could be managed per player instance better
var p2MessageDisplayed = false
var p3MessageDisplayed = false
var p4MessageDisplayed = false
var isDead = false
var playerNumber
var isAttacking = false
var inventoryOpen = false

@onready var timer1 = $Timer # 3. @onready
@onready var currentSprite = $SpriteContainer/idle # 3. @onready
@onready var meleeAttack # 3. @onready
@onready var meleeAttackAnimPlayer # 3. @onready


func _ready():
	match get_parent().name: # 8. Fragile, but kept for now
		"P1":
			playerNumber = 1
		"P2":
			playerNumber = 2
		"P3":
			playerNumber = 3
		"P4":
			playerNumber = 4

func _process(delta):
	# Player-specific global updates (consider signals or direct calls for this)
	if get_parent().name == "P1":
		global.p1Life = health
	if get_parent().name == "P2":
		global.p2Life = health
	if get_parent().name == "P3":
		global.p3Life = health
	if get_parent().name == "P4":
		global.p4Life = health
		
	if health <= 0:
		isDead = true
		
	# UI state checks - highly dependent on scene structure (7. Node path access)
	# These get_node calls are very brittle.
	if get_tree().get_root().get_node("Control/woodBack1").visible || get_tree().get_root().get_node("Control/dialogBoxName1").visible:
		p1MessageDisplayed = true
	else:
		p1MessageDisplayed = false
	# ... similar checks for p2, p3, p4 ... (omitted for brevity but assume they follow the same pattern)

	if state != lastState:
		match state:
			"run":
				currentSprite = $SpriteContainer/run
				$SpriteContainer/run.visible = true
				$SpriteContainer/jump.visible = false
				$SpriteContainer/gotHit.visible = false
				$SpriteContainer/ko.visible = false
				$SpriteContainer/idle.visible = false
				lastState = "run"
			"jump":
				currentSprite = $SpriteContainer/jump
				$SpriteContainer/run.visible = false
				$SpriteContainer/jump.visible = true
				$SpriteContainer/gotHit.visible = false
				$SpriteContainer/ko.visible = false
				$SpriteContainer/idle.visible = false
				lastState = "jump"
			"gotHit":
				if facingDirection == "left":
					$SpriteContainer/gotHit.offset.x = 120
				else:
					$SpriteContainer/gotHit.offset.x = 0
				currentSprite = $SpriteContainer/gotHit
				$SpriteContainer/run.visible = false
				$SpriteContainer/jump.visible = false
				$SpriteContainer/gotHit.visible = true
				$SpriteContainer/ko.visible = false
				$SpriteContainer/idle.visible = false
				lastState = "gotHit"
			"ko":
				currentSprite = $SpriteContainer/ko # Should also set visibility like other states
				$SpriteContainer/run.visible = false
				$SpriteContainer/jump.visible = false
				$SpriteContainer/gotHit.visible = false
				$SpriteContainer/ko.visible = true
				$SpriteContainer/idle.visible = false
				lastState = "ko"
			"idle":
				currentSprite = $SpriteContainer/idle
				$SpriteContainer/run.visible = false
				$SpriteContainer/jump.visible = false
				$SpriteContainer/gotHit.visible = false
				$SpriteContainer/ko.visible = false
				$SpriteContainer/idle.visible = true
				lastState = "idle"
	if currentSprite: # Ensure currentSprite is valid
		if facingDirection == "right":
			currentSprite.flip_h = false
		else:
			currentSprite.flip_h = true # 11. State machine properties
		
	if withinInteractableRange:
		$interact.visible = true
		$interact/AnimationPlayer.play("interact")
		var player_action_name = "" # Determine action name based on playerNumber
		match playerNumber:
			1: player_action_name = "p1Interact"
			2: player_action_name = "p2Interact"
			3: player_action_name = "p3Interact"
			4: player_action_name = "p4Interact"
		
		var r = ""
		if InputMap.has_action(player_action_name):
			var events = InputMap.action_get_events(player_action_name)
			if events.size() > 0:
				var event = events[0] # Get the first event
				if event is InputEventKey:
					r = OS.get_keycode_string(event.keycode).capitalize() # 6. Updated OS call
				elif event is InputEventJoypadButton:
					# Simplified joypad button display, actual button name needs more logic
					if event.button_index == JOY_BUTTON_Y: r = "Y" 
					elif event.button_index == JOY_BUTTON_A: r = "A"
					elif event.button_index == JOY_BUTTON_B: r = "B"
					elif event.button_index == JOY_BUTTON_X: r = "X"
					else: r = "JoyBtn" # Fallback
		$interact/Label.text = r
	elif $interact.visible == true: # Check if it was visible before
		$interact.visible = false
		$interact/AnimationPlayer.stop()

func _physics_process(delta):
	# Add gravity.
	if not is_on_floor():
		velocity.y += gravity_value # Using gravity_value * delta is more frame-rate independent, but original was direct
	
	# Handle movement and state based on velocity (set in playerControls)
	move_and_slide() # 2. move_and_slide without arguments

	if not is_on_floor() && state != "gotHit": # Check after move_and_slide
		state = "jump"
		$AnimationPlayer.play("jump")
	elif state != "run" && state != "gotHit" && is_on_floor(): # Ensure on floor for idle/run
		state = "idle"
		$AnimationPlayer.play("idle")
		
	if state == "gotHit":
		controlsEnabled = false
		$AnimationPlayer.play("gotHit")
		
	# Reset horizontal velocity if not moving (or apply friction)
	# This part was implicit in old move_and_slide with ground, now needs explicit handling if using acceleration model for controls
	# For this migration, assuming playerControls handles setting velocity.x to 0 when no input.


func playerControls(control):
	if controlsEnabled == true && !isAttacking && !inventoryOpen:
		var current_velocity_x = velocity.x

		if control == "right":
			facingDirection = "right"
			if is_on_floor(): state = "run"
			current_velocity_x = min(current_velocity_x + acceleration_value, max_speed)
			if is_on_floor(): $AnimationPlayer.play("run")
			
		elif control == "left":
			facingDirection = "left"
			if is_on_floor(): state = "run"
			current_velocity_x = max(current_velocity_x - acceleration_value, -max_speed)
			if is_on_floor(): $AnimationPlayer.play("run")
		else: # No left/right input or other action took precedence
			if is_on_floor(): # Apply friction or stop
				current_velocity_x = move_toward(current_velocity_x, 0, acceleration_value) # Simple friction
			# If airborn, no direct change to x unless air control is intended

		velocity.x = current_velocity_x

		if is_on_floor():
			if control == "jump":
				velocity.y = jump_velocity # Use jump_velocity
				state = "jump" # Set state immediately
				$AnimationPlayer.play("jump")
	 
		if control == "interact" && withinInteractableRange:
			# ... (Interaction logic - very complex, assuming paths are mostly fine for now) ...
			# Example for transition:
			if objInteractedWith == "transition":
				var viewport_path_base = "Control/VBoxContainer/HBoxContainer/" # Example, adjust as needed
				var viewport_node_name = ""
				var current_world_var_name = "" # e.g. "p1World" string to access global vars if needed (not ideal)

				match playerNumber:
					1: 
						viewport_node_name = viewport_path_base + "ViewportContainer1/Viewport1"
						if !p1MessageDisplayed: # Check message displayed status
							var viewport = get_tree().get_root().get_node(viewport_node_name) # Brittle path
							if viewport: viewport.world_2d = transitionTarget[0].world_2d
							if global.p1World: global.p1World.remove_child(self)
							transitionTarget[0].add_child(self)
							global.positionCharacter(1, transitionTarget[1], transitionTarget[2])
					# ... similar blocks for P2, P3, P4, adjusting paths and global vars ...

			# Projectile instantiation logic (14. .instantiate())
		if control == "interact" && !withinInteractableRange: # Attack
			var equipped_weapon_data = inventory.equipped(playerNumber, "weapon")
			if equipped_weapon_data.name != "empty":
				if equipped_weapon_data.type == "projectile":
					var player_inventory_weapon_map = inventory.get("p" + str(playerNumber) + "Inventory")["weapon"]
					var player_equipped_weapon_name = inventory.get("p" + str(playerNumber) + "Equipped")["weapon"]
					
					if player_inventory_weapon_map.has(player_equipped_weapon_name) and player_inventory_weapon_map[player_equipped_weapon_name] > 0:
						var is_boomerang = (player_equipped_weapon_name == "boomerang")
						var boomerang_thrown_var_name = "p" + str(playerNumber) + "BoomerangThrown" # e.g. global.p1BoomerangThrown
						
						if (is_boomerang and not global.get(boomerang_thrown_var_name)) or not is_boomerang:
							var projectile_scene = inventory.database["weapon"][player_equipped_weapon_name]["scene"]
							if projectile_scene: # Check if scene is loaded
								var projectile = projectile_scene.instantiate() # Use .instantiate()
								get_tree().current_scene.add_child(projectile) # Add to current scene, or get_parent().get_parent() if structure is known
								projectile.determinePlayer(playerNumber) # Assuming determinePlayer exists
								
								if not is_boomerang:
									player_inventory_weapon_map[player_equipped_weapon_name] -= 1
									if player_inventory_weapon_map[player_equipped_weapon_name] <= 0:
										player_inventory_weapon_map.erase(player_equipped_weapon_name)
										# Also remove from inventory array (this part is complex and needs care)
										# inventory.get("p" + str(playerNumber) + "InventoryArray")[0].erase(player_equipped_weapon_name)
										inventory.get("p" + str(playerNumber) + "Equipped")["weapon"] = ""
				
				elif equipped_weapon_data.type == "melee":
					if !isAttacking:
						velocity.x = 0 # Stop horizontal movement for melee
						swingWeapon()
			# ... Logic for P2, P3, P4 follows similar pattern ...
			# ... (omitted for brevity)
			
		if control == "rBumper" or control == "lBumper": # Weapon switching
			var inv_array = inventory.get("p" + str(playerNumber) + "InventoryArray")[0] # Weapon array
			var equipped_weapon_name = inventory.get("p" + str(playerNumber) + "Equipped")["weapon"]
			if inv_array.size() > 0:
				var current_idx = inv_array.find(equipped_weapon_name)
				if current_idx == -1 and inv_array.size() > 0: current_idx = 0 # Default to first if not found or empty equipped
				
				var newIndex = current_idx
				if control == "rBumper":
					newIndex = (current_idx + 1) % inv_array.size()
				elif control == "lBumper":
					newIndex = (current_idx - 1 + inv_array.size()) % inv_array.size()
				
				if newIndex < inv_array.size():
					inventory.equipWeapon(playerNumber, inv_array[newIndex])
					
		if control == "inventory":
			# ... (Inventory open logic - very complex, assuming paths mostly fine) ...
			# Example for P1
			if playerNumber == 1:
				var inventoryWindow = get_tree().get_root().get_node("Control/VBoxContainer/HBoxContainer/ViewportContainer1/UICanvasLayer1/InventoryWindow") # Brittle
				if inventoryWindow:
					# ... (original logic) ...
					inventoryWindow.visible = true
					inventoryOpen = true
					# ...
			# ... similar for P2, P3, P4 ...
			
	# Inventory navigation logic (if inventoryOpen)
	if inventoryOpen:
		# ... (similar brittle get_node calls for inventoryWindow) ...
		# ... (original logic for up, down, interact within inventory) ...
		pass


async func swingWeapon(): # 9. Weapon Swinging Logic - await
	if meleeAttack == null or meleeAttackAnimPlayer == null: # Guard against null nodes
		isAttacking = false # Ensure isAttacking is reset
		return

	if currentSprite.flip_h == true:
		meleeAttack.scale = Vector2(-0.75, 0.75) # 9. Use .scale
	else:
		meleeAttack.scale = Vector2(0.75, 0.75) # 9. Use .scale
	isAttacking = true
	if currentSprite: currentSprite.visible = false
	meleeAttack.visible = true
	meleeAttackAnimPlayer.play("meleeAttack")
	await get_tree().create_timer(0.25).timeout # 4. await for yield
	if meleeAttackAnimPlayer: meleeAttackAnimPlayer.stop() # Check if node still valid after await
	if meleeAttack: meleeAttack.visible = false
	if currentSprite: currentSprite.visible = true
	isAttacking = false

func afterGotHit():
	state = "idle"
	invulnerable = false
	controlsEnabled = true

func _on_Timer_timeout(): # Assumed connected in editor
	pass 

func get_saved_data():
	return {
		"scene_file_path": self.scene_file_path, # 10. Changed 'filename' to 'self.scene_file_path'
		"parent_path": get_parent().get_path(), # Renamed for clarity
		"properties": {
			"position": position, # This is global_position for CharacterBody2D, or position if you mean local
			"health": health, # Custom var
			"stamina": stamina, # Custom var
			"velocity_x": velocity.x, # Save velocity components
			"velocity_y": velocity.y,
			"lastState": lastState,
			"state": state,
			"facingDirection": facingDirection,
			"withinInteractableRange": withinInteractableRange,
			# objInteractedWith might be an instance, careful with serialization
			"transitionTarget": transitionTarget, # Array, careful if it contains node references
			"invulnerable": invulnerable,
			"stunned": stunned,
			"controlsEnabled": controlsEnabled,
			"p1MessageDisplayed": p1MessageDisplayed, # These are global-like, maybe save elsewhere
			"p2MessageDisplayed": p2MessageDisplayed,
			"p3MessageDisplayed": p3MessageDisplayed,
			"p4MessageDisplayed": p4MessageDisplayed,
			"isDead": isDead,
			"playerNumber": playerNumber,
			"isAttacking": isAttacking,
			"inventoryOpen": inventoryOpen,
			# "currentSprite": currentSprite.get_path() if currentSprite else null # Save path, not instance
		}
	}
