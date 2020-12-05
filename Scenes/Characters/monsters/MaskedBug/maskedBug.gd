extends "res://Scenes/Characters/monsters/enemyBase.gd"

func _physics_process(delta):
	if health <= 0:
		isDead = true
		state = "ko"

func get_saved_data():
	return {
		"filename": filename,
		"parent": get_parent().get_path(),
		"properties": {
			"position": position
		}
	}
