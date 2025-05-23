extends "res://Scenes/Characters/monsters/enemyBase.gd"

func _physics_process(delta):
	super._physics_process(delta) # Call base class physics process
	if health <= 0:
		isDead = true
		state = "ko"

func get_saved_data():
	# This function overrides the one in enemyBase.gd (and playerBase.gd).
	# It returns a much simpler dictionary.
	# Changing "filename": filename as per instruction.
	return {
		"scene_file_path": self.scene_file_path, # Changed from "filename": filename
		"parent": get_parent().get_path(),         # Kept original key "parent"
		"properties": {
			"position": position 
			# This version only includes position, losing other properties from base classes.
		}
	}
