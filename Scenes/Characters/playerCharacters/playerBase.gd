extends KinematicBody2D

const UP = Vector2(0, -1)
export var gravity = 40
export var acceleration = 50
export var maxSpeed = 400
export var jumpHeight = -850
export var health = 100.0
export var stamina = 100.0

var motion = Vector2()
var lastState = "idle"
var state = "idle"
var facingDirection = "right"
var withinInteractableRange = false
var objInteractedWith
var transitionTarget = [] # Map, X coord, Y coord
var invulnerable = false
var stunned = 0.0
var controlsEnabled = true
var p1MessageDisplayed = false
var p2MessageDisplayed = false
var p3MessageDisplayed = false
var p4MessageDisplayed = false
var isDead = false
var playerNumber
var isAttacking = false
var inventoryOpen = false

onready var timer1 = $Timer
onready var currentSprite = $SpriteContainer/idle
onready var meleeAttack
onready var meleeAttackAnimPlayer


func _ready():
	match get_parent().name:
		"P1":
			playerNumber = 1
		"P2":
			playerNumber = 2
		"P3":
			playerNumber = 3
		"P4":
			playerNumber = 4

func _process(delta):
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
		
	if get_tree().get_root().get_node("Control/woodBack1").visible || get_tree().get_root().get_node("Control/dialogBoxName1").visible:
		p1MessageDisplayed = true
	else:
		p1MessageDisplayed = false
	if get_tree().get_root().get_node("Control/woodBack2").visible || get_tree().get_root().get_node("Control/dialogBoxName2").visible:
		p2MessageDisplayed = true
	else:
		p2MessageDisplayed = false
	if get_tree().get_root().get_node("Control/woodBack3").visible || get_tree().get_root().get_node("Control/dialogBoxName3").visible:
		p3MessageDisplayed = true
	else:
		p3MessageDisplayed = false
	if get_tree().get_root().get_node("Control/woodBack4").visible || get_tree().get_root().get_node("Control/dialogBoxName4").visible:
		p4MessageDisplayed = true
	else:
		p4MessageDisplayed = false
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
				currentSprite = $SpriteContainer/ko
				lastState = "ko"
			"idle":
				currentSprite = $SpriteContainer/idle
				$SpriteContainer/run.visible = false
				$SpriteContainer/jump.visible = false
				$SpriteContainer/gotHit.visible = false
				$SpriteContainer/ko.visible = false
				$SpriteContainer/idle.visible = true
				lastState = "idle"
	if facingDirection == "right":
		currentSprite.flip_h = false
	else:
		currentSprite.flip_h = true
		
	if withinInteractableRange:
		$interact.visible = true
		$interact/AnimationPlayer.play("interact")
		var player
		match get_parent().name:
			"P1":
				player = "p1Interact"
			"P2":
				player = "p2Interact"
			"P3":
				player = "p3Interact"
			"P4":
				player = "p4Interact"
		var r = ""
		if !Input.is_joy_known(0):
			r = OS.get_scancode_string(InputMap.get_action_list("p1Interact")[0].scancode)
		else:
			if InputMap.get_action_list("p1Interact")[1].button_index == 3:
				r = "Y"
		$interact/Label.text = r
	elif $interact.visible == true:
		$interact.visible = false
		$interact/AnimationPlayer.stop()
	var player
	match get_parent().name:
		"P1":
			player = inventory.p1Equipped
		"P2":
			player = inventory.p2Equipped
		"P3":
			player = inventory.p3Equipped
		"P4":
			player = inventory.p4Equipped
	#print("TEST")
	#if player.weapon == "":
		#print("TEST2")

func _physics_process(delta):
	motion.y += gravity
	motion = move_and_slide(motion, UP)
	if !is_on_floor() && state != "gotHit":
		state = "jump"
		$AnimationPlayer.play("jump")
	elif state != "run" && state != "gotHit":
		state = "idle"
		$AnimationPlayer.play("idle")
	if state == "gotHit":
		controlsEnabled = false
		$AnimationPlayer.play("gotHit")
		

func playerControls(control):
	if controlsEnabled == true && !isAttacking && !inventoryOpen:
		if control == "right":
			facingDirection = "right"
			state = "run"
			motion.x = min(motion.x + acceleration, maxSpeed)
			$AnimationPlayer.play("run")
			
		elif control == "left":
			facingDirection = "left"
			state = "run"
			motion.x = max(motion.x - acceleration, -maxSpeed)
			$AnimationPlayer.play("run")
			
		if is_on_floor():
			if control == "jump":
				motion.y = jumpHeight
	 
		if control == "interact" && withinInteractableRange:
			if objInteractedWith == "transition":
				var viewport
				if get_parent().name == "P1" && !p1MessageDisplayed:
					viewport = get_tree().get_root().get_node("Control/VBoxContainer/HBoxContainer/ViewportContainer1/Viewport1")
					viewport.world_2d = transitionTarget[0].world_2d
					global.p1World.remove_child(get_parent())
					transitionTarget[0].add_child(get_parent())
					global.positionCharacter(1, transitionTarget[1], transitionTarget[2])
				if get_parent().name == "P2" && !p2MessageDisplayed: 
					viewport = get_tree().get_root().get_node("Control/VBoxContainer/HBoxContainer/ViewportContainer2/Viewport2")
					viewport.world_2d = transitionTarget[0].world_2d
					global.p2World.remove_child(get_parent())
					transitionTarget[0].add_child(get_parent())
					global.positionCharacter(2, transitionTarget[1], transitionTarget[2])
				if get_parent().name == "P3" && !p3MessageDisplayed: 
					viewport = get_tree().get_root().get_node("Control/VBoxContainer/HBoxContainer2/ViewportContainer3/Viewport3")
					viewport.world_2d = transitionTarget[0].world_2d
					global.p3World.remove_child(get_parent())
					transitionTarget[0].add_child(get_parent())
					global.positionCharacter(3, transitionTarget[1], transitionTarget[2])
				if get_parent().name == "P4" && !p4MessageDisplayed: 
					viewport = get_tree().get_root().get_node("Control/VBoxContainer/HBoxContainer2/ViewportContainer4/Viewport4")
					viewport.world_2d = transitionTarget[0].world_2d
					global.p4World.remove_child(get_parent())
					transitionTarget[0].add_child(get_parent())
					global.positionCharacter(4, transitionTarget[1], transitionTarget[2])
			if objInteractedWith == "woodenSign":
				if get_parent().name == "P1" && !p1MessageDisplayed:
					get_tree().get_root().get_node("Control/woodBack1/Label").text = global.p1Message
					get_tree().get_root().get_node("Control/woodBack1").visible = !get_tree().get_root().get_node("Control/woodBack1").visible
				elif get_parent().name == "P1" && p1MessageDisplayed:
					get_tree().get_root().get_node("Control/woodBack1").visible = !get_tree().get_root().get_node("Control/woodBack1").visible
				if get_parent().name == "P2" && !p2MessageDisplayed:
					get_tree().get_root().get_node("Control/woodBack2/Label").text = global.p2Message
					get_tree().get_root().get_node("Control/woodBack2").visible = !get_tree().get_root().get_node("Control/woodBack2").visible
				elif get_parent().name == "P2" && p2MessageDisplayed:
					get_tree().get_root().get_node("Control/woodBack2").visible = !get_tree().get_root().get_node("Control/woodBack2").visible
				if get_parent().name == "P3" && !p3MessageDisplayed:
					get_tree().get_root().get_node("Control/woodBack3/Label").text = global.p3Message
					get_tree().get_root().get_node("Control/woodBack3").visible = !get_tree().get_root().get_node("Control/woodBack3").visible
				elif get_parent().name == "P3" && p3MessageDisplayed:
					get_tree().get_root().get_node("Control/woodBack3").visible = !get_tree().get_root().get_node("Control/woodBack3").visible
				if get_parent().name == "P4" && !p4MessageDisplayed:
					get_tree().get_root().get_node("Control/woodBack4/Label").text = global.p4Message
					get_tree().get_root().get_node("Control/woodBack4").visible = !get_tree().get_root().get_node("Control/woodBack4").visible
				elif get_parent().name == "P4" && p4MessageDisplayed:
					get_tree().get_root().get_node("Control/woodBack4").visible = !get_tree().get_root().get_node("Control/woodBack4").visible
			if objInteractedWith == "message":
				if get_parent().name == "P1" && !p1MessageDisplayed:
					get_tree().get_root().get_node("Control/dialogBoxName1")._displayText(global.p1InteractName, global.p1Message)
					get_tree().get_root().get_node("Control/dialogBoxName1").visible = !get_tree().get_root().get_node("Control/dialogBoxName1").visible
				elif get_parent().name == "P1" && p1MessageDisplayed:
					get_tree().get_root().get_node("Control/dialogBoxName1").processLongMessage()
				if get_parent().name == "P2" && !p2MessageDisplayed:
					get_tree().get_root().get_node("Control/dialogBoxName2")._displayText(global.p2InteractName, global.p2Message)
					get_tree().get_root().get_node("Control/dialogBoxName2").visible = !get_tree().get_root().get_node("Control/dialogBoxName2").visible
				elif get_parent().name == "P2" && p2MessageDisplayed:
					get_tree().get_root().get_node("Control/dialogBoxName2").processLongMessage()
				if get_parent().name == "P3" && !p3MessageDisplayed:
					get_tree().get_root().get_node("Control/dialogBoxName3")._displayText(global.p3InteractName, global.p3Message)
					get_tree().get_root().get_node("Control/dialogBoxName3").visible = !get_tree().get_root().get_node("Control/dialogBoxName3").visible
				elif get_parent().name == "P3" && p3MessageDisplayed:
					get_tree().get_root().get_node("Control/dialogBoxName3").processLongMessage()
				if get_parent().name == "P4" && !p4MessageDisplayed:
					get_tree().get_root().get_node("Control/dialogBoxName4")._displayText(global.p4InteractName, global.p4Message)
					get_tree().get_root().get_node("Control/dialogBoxName4").visible = !get_tree().get_root().get_node("Control/dialogBoxName4").visible
				elif get_parent().name == "P4" && p4MessageDisplayed:
					get_tree().get_root().get_node("Control/dialogBoxName4").processLongMessage()
		if control == "interact" && !withinInteractableRange:
			if get_parent().name == "P1":
				if inventory.equipped(1, "weapon").name != "empty":
					if inventory.equipped(1, "weapon").type == "projectile":
						if inventory.p1Inventory["weapon"][inventory.equipped(1, "weapon").name] > 0:
							if (inventory.p1Equipped["weapon"] == "boomerang" && !global.p1BoomerangThrown) || inventory.p1Equipped["weapon"] != "boomerang":
								var projectile = inventory.database["weapon"][inventory.p1Equipped["weapon"]]["scene"].instance()
								get_parent().get_parent().add_child(projectile)
								projectile.determinePlayer(1)
								if inventory.p1Equipped["weapon"] != "boomerang":
									inventory.p1Inventory["weapon"][inventory.p1Equipped["weapon"]] -= 1
								if inventory.p1Inventory["weapon"][inventory.p1Equipped["weapon"]] <= 0:
									inventory.p1Inventory["weapon"].erase(inventory.p1Equipped["weapon"])
									inventory.p1InventoryArray[0].erase(inventory.p1Equipped["weapon"])
									inventory.p1Equipped["weapon"] = ""
								
					elif inventory.database["weapon"][inventory.p1Equipped["weapon"]]["type"] == "melee":
						if !isAttacking:
							motion.x = 0
							swingWeapon()
							
			if get_parent().name == "P2":
				if inventory.equipped(2, "weapon").name != "empty":
					if inventory.equipped(2, "weapon").type == "projectile":
						if inventory.p2Inventory["weapon"][inventory.equipped(2, "weapon").name] > 0:
							if inventory.p2Equipped["weapon"] == "boomerang" && !global.p1BoomerangThrown:
								var projectile = inventory.database["weapon"][inventory.p2Equipped["weapon"]]["scene"].instance()
								get_parent().get_parent().add_child(projectile)
								projectile.determinePlayer(2)
								if inventory.p2Equipped["weapon"] != "boomerang":
									inventory.p2Inventory["weapon"][inventory.p2Equipped["weapon"]] -= 1
								if inventory.p2Inventory["weapon"][inventory.p2Equipped["weapon"]] <= 0:
									inventory.p2Inventory["weapon"].erase(inventory.p2Equipped["weapon"])
									inventory.p2InventoryArray[0].erase(inventory.p1Equipped["weapon"])
									inventory.p2Equipped["weapon"] = ""
					elif inventory.database["weapon"][inventory.p2Equipped["weapon"]]["type"] == "melee":
						if !isAttacking:
							motion.x = 0
							swingWeapon()
							
			if get_parent().name == "P3":
				if inventory.equipped(3, "weapon").name != "empty":
					if inventory.equipped(3, "weapon").type == "projectile":
						if inventory.p3Inventory["weapon"][inventory.equipped(3, "weapon").name] > 0:
							if inventory.p3Equipped["weapon"] == "boomerang" && !global.p1BoomerangThrown:
								var projectile = inventory.database["weapon"][inventory.p3Equipped["weapon"]]["scene"].instance()
								get_parent().get_parent().add_child(projectile)
								projectile.determinePlayer(3)
								if inventory.p3Equipped["weapon"] != "boomerang":
									inventory.p3Inventory["weapon"][inventory.p3Equipped["weapon"]] -= 1
								if inventory.p3Inventory["weapon"][inventory.p3Equipped["weapon"]] <= 0:
									inventory.p3Inventory["weapon"].erase(inventory.p3Equipped["weapon"])
									inventory.p3InventoryArray[0].erase(inventory.p1Equipped["weapon"])
									inventory.p3Equipped["weapon"] = ""
					elif inventory.database["weapon"][inventory.p3Equipped["weapon"]]["type"] == "melee":
						if !isAttacking:
							motion.x = 0
							swingWeapon()
							
			if get_parent().name == "P4":
				if inventory.equipped(4, "weapon").name != "empty":
					if inventory.equipped(4, "weapon").type == "projectile":
						if inventory.p4Inventory["weapon"][inventory.equipped(4, "weapon").name] > 0:
							if inventory.p4Equipped["weapon"] == "boomerang" && !global.p1BoomerangThrown:
								var projectile = inventory.database["weapon"][inventory.p4Equipped["weapon"]]["scene"].instance()
								get_parent().get_parent().add_child(projectile)
								projectile.determinePlayer(4)
								if inventory.p4Equipped["weapon"] != "boomerang":
									inventory.p4Inventory["weapon"][inventory.p4Equipped["weapon"]] -= 1
								if inventory.p4Inventory["weapon"][inventory.p4Equipped["weapon"]] <= 0:
									inventory.p4Inventory["weapon"].erase(inventory.p4Equipped["weapon"])
									inventory.p4InventoryArray[0].erase(inventory.p1Equipped["weapon"])
									inventory.p4Equipped["weapon"] = ""
					elif inventory.database["weapon"][inventory.p4Equipped["weapon"]]["type"] == "melee":
						if !isAttacking:
							motion.x = 0
							swingWeapon()
						
		if control == "rBumper":
			match get_parent().name:
				"P1":
					var newIndex = inventory.p1InventoryArray[0].find(inventory.p1Equipped["weapon"]) + 1
					if newIndex > inventory.p1InventoryArray[0].size() - 1:
						newIndex = 0
					inventory.equipWeapon(1, inventory.p1InventoryArray[0][newIndex])
				"P2":
					var newIndex = inventory.p2InventoryArray[0].find(inventory.p2Equipped["weapon"]) + 1
					if newIndex > inventory.p2InventoryArray[0].size() - 1:
						newIndex = 0
					inventory.equipWeapon(2, inventory.p2InventoryArray[0][newIndex])
				"P3":
					var newIndex = inventory.p3InventoryArray[0].find(inventory.p3Equipped["weapon"]) + 1
					if newIndex > inventory.p3InventoryArray[0].size() - 1:
						newIndex = 0
					inventory.equipWeapon(3, inventory.p3InventoryArray[0][newIndex])
				"P4":
					var newIndex = inventory.p4InventoryArray[0].find(inventory.p4Equipped["weapon"]) + 1
					if newIndex > inventory.p4InventoryArray[0].size() - 1:
						newIndex = 0
					inventory.equipWeapon(4, inventory.p4InventoryArray[0][newIndex])
					
		if control == "lBumper":
			match get_parent().name:
				"P1":
					var newIndex = inventory.p1InventoryArray[0].find(inventory.p1Equipped["weapon"]) - 1
					if newIndex < 0:
						newIndex = inventory.p1InventoryArray[0].size() - 1
					inventory.equipWeapon(1, inventory.p1InventoryArray[0][newIndex])
				"P2":
					var newIndex = inventory.p2InventoryArray[0].find(inventory.p2Equipped["weapon"]) - 1
					if newIndex < 0:
						newIndex = inventory.p2InventoryArray[0].size() - 1
					inventory.equipWeapon(2, inventory.p2InventoryArray[0][newIndex])
				"P3":
					var newIndex = inventory.p3InventoryArray[0].find(inventory.p3Equipped["weapon"]) - 1
					if newIndex < 0:
						newIndex = inventory.p3InventoryArray[0].size() - 1
					inventory.equipWeapon(3, inventory.p3InventoryArray[0][newIndex])
				"P4":
					var newIndex = inventory.p4InventoryArray[0].find(inventory.p4Equipped["weapon"]) - 1
					if newIndex < 0:
						newIndex = inventory.p4InventoryArray[0].size() - 1
					inventory.equipWeapon(4, inventory.p4InventoryArray[0][newIndex])
					
		if control == "inventory":
			$AnimationPlayer.stop()
			motion.x = 0
			var inventoryWindow
			match get_parent().name:
				"P1":
					inventoryWindow = get_tree().get_root().get_node("Control/VBoxContainer/HBoxContainer/ViewportContainer1/UICanvasLayer1/InventoryWindow")
					inventoryWindow.curIndex = 0
					inventoryWindow.selector.position = inventoryWindow.actualIndexPlaces[inventoryWindow.curIndex]
					inventoryWindow.updateItemAmountText()
					inventoryWindow.visible = true
					inventoryOpen = true
					inventoryWindow.inventoryWindowOpened()
					inventoryWindow.setSliderStart()
					return
				"P2":
					inventoryWindow = get_tree().get_root().get_node("Control/VBoxContainer/HBoxContainer/ViewportContainer2/UICanvasLayer2/InventoryWindow2")
					inventoryWindow.curIndex = 0
					inventoryWindow.selector.position = inventoryWindow.actualIndexPlaces[inventoryWindow.curIndex]
					inventoryWindow.updateItemAmountText()
					inventoryWindow.visible = true
					inventoryOpen = true
					inventoryWindow.inventoryWindowOpened()
					inventoryWindow.setSliderStart()
					return
				"P3":
					inventoryWindow = get_tree().get_root().get_node("Control/VBoxContainer/HBoxContainer2/ViewportContainer3/UICanvasLayer3/InventoryWindow3")
					inventoryWindow.curIndex = 0
					inventoryWindow.selector.position = inventoryWindow.actualIndexPlaces[inventoryWindow.curIndex]
					inventoryWindow.updateItemAmountText()
					inventoryWindow.visible = true
					inventoryOpen = true
					inventoryWindow.inventoryWindowOpened()
					inventoryWindow.setSliderStart()
					return
				"P4":
					inventoryWindow = get_tree().get_root().get_node("Control/VBoxContainer/HBoxContainer2/ViewportContainer4/UICanvasLayer4/InventoryWindow4")
					inventoryWindow.curIndex = 0
					inventoryWindow.selector.position = inventoryWindow.actualIndexPlaces[inventoryWindow.curIndex]
					inventoryWindow.updateItemAmountText()
					inventoryWindow.visible = true
					inventoryOpen = true
					inventoryWindow.inventoryWindowOpened()
					inventoryWindow.setSliderStart()
					return
	if inventoryOpen:
		var inventoryWindow
		match get_parent().name:
			"P1":
				inventoryWindow = get_tree().get_root().get_node("Control/VBoxContainer/HBoxContainer/ViewportContainer1/UICanvasLayer1/InventoryWindow")
			"P2":
				inventoryWindow = get_tree().get_root().get_node("Control/VBoxContainer/HBoxContainer/ViewportContainer2/UICanvasLayer2/InventoryWindow2")
			"P3":
				inventoryWindow = get_tree().get_root().get_node("Control/VBoxContainer/HBoxContainer2/ViewportContainer3/UICanvasLayer3/InventoryWindow3")
			"P4":
				inventoryWindow = get_tree().get_root().get_node("Control/VBoxContainer/HBoxContainer2/ViewportContainer4/UICanvasLayer4/InventoryWindow4")
		if control == "inventory":
			match get_parent().name:
					"P1":
						inventoryWindow.updateItemAmountText()
						inventoryWindow.visible = false
						inventoryOpen = false
						return
					"P2":
						inventoryWindow.updateItemAmountText()
						inventoryWindow.visible = false
						inventoryOpen = false
						return
					"P3":
						inventoryWindow.updateItemAmountText()
						inventoryWindow.visible = false
						inventoryOpen = false
						return
					"P4":
						inventoryWindow.updateItemAmountText()
						inventoryWindow.visible = false
						inventoryOpen = false
						return
		if control == "up":
			inventoryWindow.moveSelector("up")
		if control == "down":
			inventoryWindow.moveSelector("down")
		if control == "right":
			inventoryWindow.moveSelector("right")
		if control == "left":
			inventoryWindow.moveSelector("left")
		if control == "interact":
			inventoryWindow.useSelected()
			
func swingWeapon():
	if currentSprite.flip_h == true:
		meleeAttack.set_scale(Vector2(-0.75, 0.75))
	else:
		meleeAttack.set_scale(Vector2(0.75, 0.75))
	isAttacking = true
	currentSprite.visible = false
	meleeAttack.visible = true
	meleeAttackAnimPlayer.play("meleeAttack")
	yield(get_tree().create_timer(0.25), "timeout")
	meleeAttackAnimPlayer.stop()
	meleeAttack.visible = false
	currentSprite.visible = true
	isAttacking = false

func afterGotHit():
	state = "idle"
	invulnerable = false
	controlsEnabled = true

func _on_Timer_timeout():
	pass # Replace with function body.

func get_saved_data():
	return {
		"filename": filename,
		"parent": get_parent().get_path(),
		"properties": {
			"position": position,
			"lastState": lastState,
			"state": state,
			"facingDirection": facingDirection,
			"withinInteractableRange": withinInteractableRange,
			"transitionTarget": transitionTarget,
			"invulnerable": invulnerable,
			"stunned": stunned,
			"controlsEnabled": controlsEnabled,
			"p1MessageDisplayed": p1MessageDisplayed,
			"p2MessageDisplayed": p2MessageDisplayed,
			"p3MessageDisplayed": p3MessageDisplayed,
			"p4MessageDisplayed": p4MessageDisplayed,
			"isDead": isDead,
			"playerNumber": playerNumber,
			"isAttacking": isAttacking,
			"inventoryOpen": inventoryOpen,
			"currentSprite": currentSprite,
		}
	}
