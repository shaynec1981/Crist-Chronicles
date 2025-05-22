extends "res://Scenes/Characters/playerCharacters/playerBase.gd"

@onready var meleeAttack = $SpriteContainer/WomanMelee
@onready var meleeAttackAnimPlayer = $SpriteContainer/WomanMelee/AnimationPlayer

func _ready():
	# Assignments are now handled by @onready.
	# Call super._ready() if playerBase has _ready logic.
	super._ready()
	pass

func get_saved_data():
	# This function overrides playerBase.get_saved_data().
	# It returns a much simpler dictionary.
	# The instruction is to change "filename": filename to "scene_file_path": self.scene_file_path.
	# The base class (playerBase.gd) already includes "scene_file_path": self.scene_file_path
	# and "parent_path": get_parent().get_path() (which I named it).
	# This version keeps "parent" as the key for parent path.
	return {
		"scene_file_path": self.scene_file_path, # Changed from "filename": filename
		"parent": get_parent().get_path(),       # Kept original key "parent"
		"properties": {
			"position": position 
			# This version only includes position, losing other properties from playerBase.
		}
	}
