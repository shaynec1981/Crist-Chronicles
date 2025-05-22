extends CharacterBody2D # 1. Base Class

const UP_DIRECTION = Vector2.UP # 2. UP_DIRECTION
export var gravity_value = 40 # Renamed
export var acceleration_value = 50 # Renamed
export var max_speed = 300 # Renamed
export var health = 100
export var mainAttackPower = 1

var velocity = Vector2() # 2. Renamed motion to velocity
var lastState = "idle"
var state = "idle"
var currentSprite: Sprite2D # Type hint for clarity
var target # Should be a Node2D or CharacterBody2D
var targetDirection # String: "left" or "right"
var attackAnimDone = true
var isDead = false
var isHit = false
var gotHitProcessing = false
var deathProcessing = false

@onready var timer1: Timer = $Timer1 # 3. @onready and type hint
@onready var timer2: Timer = $Timer2 # 3. @onready and type hint
@onready var chaseLeft: RayCast2D = $RayCast2DLeftChase # 3. @onready and type hint
@onready var chaseRight: RayCast2D = $RayCast2DRightChase # 3. @onready and type hint
@onready var attackLeft: RayCast2D = $RayCast2DLeftAttack # 3. @onready and type hint
@onready var attackRight: RayCast2D = $RayCast2DRightAttack # 3. @onready and type hint
@onready var animation_player: AnimationPlayer = $AnimationPlayer # Assuming $AnimationPlayer exists
@onready var sprite_container: Node2D = $spriteContainer # Assuming $spriteContainer exists
@onready var particles_2d: CPUParticles2D = $Particles2D # Assuming $Particles2D exists and is CPUParticles2D or GPUParticles2D

func _ready():
	currentSprite = sprite_container.get_node("idle") as Sprite2D # Ensure correct type
	
func _process(delta):
	if state != lastState:
		# Ensure all sprite nodes are correctly referenced via sprite_container
		var new_sprite_node_name = state
		if state == "chasing": new_sprite_node_name = "run" # Map state name to sprite name if different

		for child in sprite_container.get_children():
			if child is Sprite2D: # Or AnimatedSprite2D if that's what they are
				child.visible = (child.name == new_sprite_node_name)
		
		currentSprite = sprite_container.get_node(new_sprite_node_name) as Sprite2D
		
		if state == "gotHit" or state == "ko":
			# Preserve flip_h from previous sprite if needed, but new currentSprite is already set
			# The original logic for this was a bit convoluted. Simpler:
			# var previous_flip_h = currentSprite.flip_h # This currentSprite is already the new one.
			# Need to get flip_h from the sprite that was visible *before* changing state.
			# This might require temporarily storing the last active sprite's flip_h if essential.
			# For now, let's assume flip_h is handled by facingDirection logic later.
			pass

		lastState = state

	# Handle sprite flipping based on targetDirection or facing (if target is null)
	var flip_sprite = false
	if targetDirection == "left":
		flip_sprite = false # Assuming sprites face right by default
	elif targetDirection == "right":
		flip_sprite = true
	
	if currentSprite: # Ensure currentSprite is not null
		currentSprite.flip_h = flip_sprite

	match state:
		"idle":
			idleState()
		"chasing":
			chaseState()
		"attacking":
			attackState()
		"gotHit":
			if not gotHitProcessing:
				gotHitState()
		"ko":
			if not deathProcessing:
				koState()
			
func idleState():
	velocity.x = 0
	# Flip_h is handled in _process now
	if animation_player.current_animation != "idle": # 7. AnimationPlayer current_animation
		animation_player.play("idle")
	
func chaseState():
	# Flip_h is handled in _process
	if animation_player.current_animation != "walking":
		animation_player.play("walking")

	if targetDirection == "left":
		velocity.x = max(velocity.x - acceleration_value, -max_speed)
	else: # targetDirection == "right"
		velocity.x = min(velocity.x + acceleration_value, max_speed)
	# Removed erroneous lerp call (see point 5 in analysis)
	
func attackState():
	# Flip_h is handled in _process
	if animation_player.current_animation != "attack" or not animation_player.is_playing(): # Check if not already playing
		attackAnimDone = false
		animation_player.play("attack") # Animation should handle setting attackAnimDone via call method track
		
func finishAttackAnim(): # Called by AnimationPlayer
	attackAnimDone = true
	
async func gotHitState(): # 4. await
	if velocity.x != 0:
		velocity.x = 0
	gotHitProcessing = true
	animation_player.stop() # Stop current animation before playing another
	animation_player.speed_scale = 4 # 7. AnimationPlayer speed_scale
	animation_player.play("gotHit")
	await get_tree().create_timer(0.25).timeout # 4. await
	if animation_player: animation_player.stop() # Check if node still exists
	if animation_player: animation_player.speed_scale = 1
	isHit = false
	gotHitProcessing = false
	state = "idle"
	
async func koState(): # 4. await
	if velocity.x != 0:
		velocity.x = 0
	deathProcessing = true
	animation_player.stop()
	animation_player.play("ko")
	await get_tree().create_timer(0.5).timeout # 4. await
	if particles_2d: # Check if node exists
		particles_2d.visible = true
		particles_2d.emitting = true
	await get_tree().create_timer(2).timeout # 4. await
	queue_free()
	
func _physics_process(delta):
	velocity.y += gravity_value # Apply gravity (original didn't use delta here)
	
	# Call move_and_slide. This function will modify velocity if a collision occurs.
	move_and_slide() # 2. Movement

	if !isDead && !isHit:
		# Chase check
		if state != "attacking" && timer1.is_stopped(): # 10. Timer check
			var new_target = null
			var new_direction = ""
			var shortest_distance = INF

			if chaseLeft.is_colliding():
				var collider_left = chaseLeft.get_collider()
				if collider_left: # Ensure collider exists
					var dist_left = global.distanceBetween(self, collider_left) # 8. global call
					if dist_left < shortest_distance:
						shortest_distance = dist_left
						new_target = collider_left
						new_direction = "left"
			
			if chaseRight.is_colliding():
				var collider_right = chaseRight.get_collider()
				if collider_right: # Ensure collider exists
					var dist_right = global.distanceBetween(self, collider_right) # 8. global call
					if dist_right < shortest_distance:
						# shortest_distance = dist_right # This was missing in original logic if left was shorter
						new_target = collider_right
						new_direction = "right"
			
			if new_target:
				timer1.start() # Assuming timer1 is for re-check delay
				target = new_target
				targetDirection = new_direction
				state = "chasing"
			# This simplified logic picks the closer of the two, or one if only one is colliding.
			# The original logic had a slight flaw if left was closer but right also collided.
			
		# Idle check (if no target from chase and not attacking)
		if target == null && state != "attacking" && (!chaseLeft.is_colliding() && !chaseRight.is_colliding() && !attackLeft.is_colliding() && !attackRight.is_colliding()):
			state = "idle"
		
		# If was attacking but target out of attack range, go idle (or chase if still in chase range)
		if state == "attacking":
			var still_in_attack_range = false
			if targetDirection == "left" and attackLeft.is_colliding() and attackLeft.get_collider() == target:
				still_in_attack_range = true
			elif targetDirection == "right" and attackRight.is_colliding() and attackRight.get_collider() == target:
				still_in_attack_range = true
			
			if not still_in_attack_range:
				# Check if still in chase range
				var still_in_chase_range = false
				if targetDirection == "left" and chaseLeft.is_colliding() and chaseLeft.get_collider() == target:
					still_in_chase_range = true
				elif targetDirection == "right" and chaseRight.is_colliding() and chaseRight.get_collider() == target:
					still_in_chase_range = true
				
				if still_in_chase_range:
					state = "chasing"
				else:
					target = null # Clear target if out of all ranges
					state = "idle"

		# Attack check (if not already attacking and a target is in attack range)
		if state != "attacking":
			if attackLeft.is_colliding():
				var collider = attackLeft.get_collider()
				if collider: # Check if collider exists
					target = collider
					targetDirection = "left"
					state = "attacking"
			elif attackRight.is_colliding(): # Use elif to prioritize left if both somehow true
				var collider = attackRight.get_collider()
				if collider:
					target = collider
					targetDirection = "right"
					state = "attacking"
		
func hitCheck(): # Called from AnimationPlayer
	if target and target.has_method("hitCheck"): # Check if target is valid and can be hit
		if targetDirection == "left":
			if attackLeft.is_colliding() && attackLeft.get_collider() == target && target.invulnerable == false:
				target.controlsEnabled = false
				target.velocity.x = 0 # Use velocity
				target.state = "gotHit"
				target.invulnerable = true
				target.health -= mainAttackPower
		else: # targetDirection == "right"
			if attackRight.is_colliding() && attackRight.get_collider() == target && target.invulnerable == false:
				target.controlsEnabled = false
				target.velocity.x = 0 # Use velocity
				target.state = "gotHit"
				target.invulnerable = true
				target.health -= mainAttackPower

func _on_Timer1_timeout(): # Editor-connected signal
	pass # Can be used to reset chase check cooldown or similar logic
