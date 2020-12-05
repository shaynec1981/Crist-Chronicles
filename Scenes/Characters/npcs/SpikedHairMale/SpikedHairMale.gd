extends "res://Scenes/Characters/npcs/npcBase.gd"

func get_saved_data():
	return {
		"filename": filename,
		"parent": get_parent().get_path(),
		"properties": {
			"position": position
		}
	}
