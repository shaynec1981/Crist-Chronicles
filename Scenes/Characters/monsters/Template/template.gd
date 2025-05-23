extends "res://Scenes/Characters/monsters/enemyBase.gd"

func _physics_process(delta):
	super._physics_process(delta) # Call base class physics process
	if health <= 0:
		isDead = true
		state = "ko"
