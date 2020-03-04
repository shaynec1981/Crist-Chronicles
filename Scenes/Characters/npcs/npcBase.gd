extends KinematicBody2D

const UP = Vector2(0, -1)
export var gravity = 40
export var acceleration = 50

var motion = Vector2()

func _physics_process(delta):
	motion.y += gravity
	motion = move_and_slide(motion, UP)
