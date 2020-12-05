extends "res://Scenes/Characters/playerCharacters/playerBase.gd"

func _ready():
	meleeAttack = get_node("SpriteContainer/WomanMelee")
	meleeAttackAnimPlayer = get_node("SpriteContainer/WomanMelee/AnimationPlayer")

func get_saved_data():
	return {
		"filename": filename,
		"parent": get_parent().get_path(),
		"properties": {
			"position": position
		}
	}
