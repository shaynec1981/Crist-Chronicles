extends Node2D

var dialogboxPScene = preload("res://Scenes/Main/DialogueBox.tscn")
var dialogbox

func _ready():
	dialogbox = dialogboxPScene.instance()
	add_child(dialogbox)
	dialogbox._displayText("Angel", "This is some test text.")

	
