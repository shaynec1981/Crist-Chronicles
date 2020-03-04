extends KinematicBody2D

const UP = Vector2(0, -1)
export var gravity = 40
export var acceleration = 50
export var maxSpeed = 300
export var health = 100
export var mainAttackPower = 1

var motion = Vector2()
var lastState = "idle"
var state = "idle"
var currentSprite
var target
var targetDirection
var attackAnimDone = true
var isDead = false
var isHit = false
var gotHitProcessing = false
var deathProcessing = false

onready var timer1 = $Timer1
onready var timer2 = $Timer2
onready var chaseLeft = $RayCast2DLeftChase
onready var chaseRight = $RayCast2DRightChase
onready var attackLeft = $RayCast2DLeftAttack
onready var attackRight = $RayCast2DRightAttack

func _ready():
	currentSprite = $spriteContainer/idle
	
func _process(delta):
	if state != lastState:
		match state:
			"chasing":
				currentSprite = $spriteContainer/run
				$spriteContainer/run.visible = true
				$spriteContainer/gotHit.visible = false
				$spriteContainer/ko.visible = false
				$spriteContainer/idle.visible = false
				$spriteContainer/attack.visible = false
				lastState = "chasing"
			"attacking":
				currentSprite = $spriteContainer/attack
				$spriteContainer/run.visible = false
				$spriteContainer/gotHit.visible = false
				$spriteContainer/ko.visible = false
				$spriteContainer/idle.visible = false
				$spriteContainer/attack.visible = true
				lastState = "chasing"
			"gotHit":
				var flipSprite = currentSprite.flip_h
				currentSprite = $spriteContainer/gotHit
				currentSprite.flip_h = flipSprite
				$spriteContainer/run.visible = false
				$spriteContainer/gotHit.visible = true
				$spriteContainer/ko.visible = false
				$spriteContainer/idle.visible = false
				$spriteContainer/attack.visible = false
				lastState = "gotHit"
			"ko":
				var flipSprite = currentSprite.flip_h
				currentSprite = $spriteContainer/ko
				currentSprite.flip_h = flipSprite
				$spriteContainer/run.visible = false
				$spriteContainer/gotHit.visible = false
				$spriteContainer/ko.visible = true
				$spriteContainer/idle.visible = false
				$spriteContainer/attack.visible = false
				lastState = "ko"
			"idle":
				currentSprite = $spriteContainer/idle
				$spriteContainer/run.visible = false
				$spriteContainer/gotHit.visible = false
				$spriteContainer/ko.visible = false
				$spriteContainer/idle.visible = true
				$spriteContainer/attack.visible = false
				lastState = "idle"
	match state:
		"idle":
			idleState()
		"chasing":
			chaseState()
		"attacking":
			attackState()
		"gotHit":
			if gotHitProcessing == false:
				gotHitState()
		"ko":
			if deathProcessing == false:
				koState()
			
func idleState():
	motion.x = 0
	if targetDirection == "left":
		$spriteContainer/idle.flip_h = false
	else:
		$spriteContainer/idle.flip_h = true
	$AnimationPlayer.play("idle")
	
func chaseState():
	if targetDirection == "left":
		$spriteContainer/run.flip_h = false
		if $AnimationPlayer.assigned_animation != "walking":
			$AnimationPlayer.play("walking")
		motion.x = max(motion.x - acceleration, -maxSpeed)
	else:
		$spriteContainer/run.flip_h = true
		if $AnimationPlayer.assigned_animation != "walking":
			$AnimationPlayer.play("walking")
		motion.x = min(motion.x + acceleration, maxSpeed)
	lerp(self.motion.x, target.position.x, 0.2)
	
func attackState():
	if targetDirection == "left":
		$spriteContainer/attack.flip_h = false
		if $AnimationPlayer.assigned_animation != "attack":
			attackAnimDone = false
			$AnimationPlayer.play("attack")
	else:
		$spriteContainer/attack.flip_h = true
		if $AnimationPlayer.assigned_animation != "attack":
			attackAnimDone = false
			$AnimationPlayer.play("attack")
		
func finishAttackAnim():
	attackAnimDone = true
	
func gotHitState():
	if motion.x != 0:
		motion.x = 0
	gotHitProcessing = true
	$AnimationPlayer.stop()
	$AnimationPlayer.set_speed_scale(4)
	$AnimationPlayer.play("gotHit")
	yield(get_tree().create_timer(0.25), "timeout")
	$AnimationPlayer.stop()
	$AnimationPlayer.set_speed_scale(1)
	isHit = false
	gotHitProcessing = false
	state = "idle"
	
func koState():
	if motion.x != 0:
		motion.x = 0
	deathProcessing = true
	$AnimationPlayer.stop()
	$AnimationPlayer.play("ko")
	yield(get_tree().create_timer(0.5), "timeout")
	$Particles2D.visible = true
	$Particles2D.emitting = true
	yield(get_tree().create_timer(2), "timeout")
	queue_free()
	
func _physics_process(delta):
	motion.y += gravity
	motion = move_and_slide(motion, UP)
	if !isDead && !isHit:
		# Chase check
		if state != "attacking" && timer1.time_left == 0:
			if chaseLeft.is_colliding() && chaseRight.is_colliding():
				timer1.start()
				var leftDistance = global.distanceBetween(self, chaseLeft.get_collider())
				var rightDistance = global.distanceBetween(self, chaseRight.get_collider())
				if leftDistance == min(leftDistance, rightDistance):
					target = chaseLeft.get_collider()
					targetDirection = "left"
					state = "chasing"
				else:
					target = chaseRight.get_collider()
					targetDirection = "right"
					state = "chasing"
			else:
				if chaseLeft.is_colliding():
					target = chaseLeft.get_collider()
					targetDirection = "left"
					state = "chasing"
				if chaseRight.is_colliding():
					target = chaseRight.get_collider()
					targetDirection = "right"
					state = "chasing"
					
		# Idle check
		if !chaseLeft.is_colliding() && !chaseRight.is_colliding() && !attackLeft.is_colliding() && !attackRight.is_colliding():
			target = null
			state = "idle"
		if state == "attacking" && (!attackLeft.is_colliding() && !attackRight.is_colliding()):
			target = null
			state = "idle"
			
		# Attack check
		if attackLeft.is_colliding():
			targetDirection == "left"
			state = "attacking"
		elif attackRight.is_colliding():
			targetDirection == "right"
			state = "attacking"
		if (state == "attacking" && targetDirection == "left") && !attackLeft.is_colliding():
			if attackRight.is_colliding():
				target = attackRight.get_collider()
				targetDirection = "right"
		if (state == "attacking" && targetDirection == "right") && !attackRight.is_colliding():
			if attackLeft.is_colliding():
				target = attackLeft.get_collider()
				targetDirection = "left"
		
func hitCheck():
	# Called from AnimationPlayer
	if targetDirection == "left":
		if attackLeft.is_colliding() && target.invulnerable == false:
			target.controlsEnabled = false
			target.motion.x = 0
			target.state = "gotHit"
			target.invulnerable = true
			target.health -= mainAttackPower
	else:
		if attackRight.is_colliding() && target.invulnerable == false:
			target.controlsEnabled = false
			target.motion.x = 0
			target.state = "gotHit"
			target.invulnerable = true
			target.health -= mainAttackPower

func _on_Timer1_timeout():
	pass
