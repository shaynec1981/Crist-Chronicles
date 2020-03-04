extends "res://Scenes/Characters/monsters/enemyBase.gd"

func _physics_process(delta):
	if health <= 0:
		isDead = true
		state = "ko"


