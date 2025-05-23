extends Node2D

# Preload the scene for the dialog box
var dialogboxPScene = preload("res://Scenes/Main/DialogueBox.tscn")

# 'dialogbox' class member removed as it's only used locally in _ready()

func _ready():
	# Instantiate the dialog box scene and make it a local variable
	var dialogbox_node = dialogboxPScene.instantiate() # Changed from .instance()
	add_child(dialogbox_node)
	
	# Call the _displayText method on the instantiated dialog box
	# This method is defined in the DialogueBox.gd script (and its variants)
	dialogbox_node._displayText("Angel", "This is some test text.")

# Ensure a newline at the end of the file for good practice.
