extends Node

@onready var nameLabel = $HUD/NameLabel
@onready var heart1 = $HUD/HeartsHBoxContainer/Heart1
@onready var heart2 = $HUD/HeartsHBoxContainer/Heart2
@onready var heart3 = $HUD/HeartsHBoxContainer/Heart3

var player
var playerLife = 6

func _ready():
	match global.numOfPlayers:
		1:
			if get_parent().name == "ViewportContainer2" || get_parent().name == "ViewportContainer3" || get_parent().name == "ViewportContainer4":
				$HUD.visible = false # Changed from get_node("HUD")
		2:
			if get_parent().name == "ViewportContainer3" || get_parent().name == "ViewportContainer4":
				$HUD.visible = false # Changed from get_node("HUD")
		3:
			if get_parent().name == "ViewportContainer4":
				$HUD.visible = false # Changed from get_node("HUD")
	
func _process(delta):
	if nameLabel.text == "Temp" && global.p1CharName != null: # Assuming p1CharName is a relevant check for all players initially
		nameLabelsUpdate()
	
	# Life Check
	if nameLabel.text != "Temp": # Ensure player has been set by nameLabelsUpdate
		match player: # player variable is set in nameLabelsUpdate
			1:
				if playerLife != global.p1Life:
					playerLife = global.p1Life
					updateHearts(playerLife)
			2:
				if playerLife != global.p2Life:
					playerLife = global.p2Life
					updateHearts(playerLife)
			3:
				if playerLife != global.p3Life:
					playerLife = global.p3Life
					updateHearts(playerLife)
			4:
				if playerLife != global.p4Life:
					playerLife = global.p4Life
					updateHearts(playerLife)
					
func nameLabelsUpdate():
	# This logic relies on the parent's name, which is fragile.
	if get_parent().name == "ViewportContainer1":
		player = 1
		if global.p1CharName != null: # Check if char name is available
			match global.p1CharName:
				"BeardedMan":
					nameLabel.text = "Shayne"
				"Woman":
					nameLabel.text = "Angel"
		else:
			nameLabel.text = "Player 1" # Default if no char name
	elif get_parent().name == "ViewportContainer2":
		player = 2
		if global.p2CharName != null:
			match global.p2CharName:
				"BeardedMan":
					nameLabel.text = "Shayne"
				"Woman":
					nameLabel.text = "Angel"
		else:
			nameLabel.text = "Player 2"
	elif get_parent().name == "ViewportContainer3":
		player = 3
		if global.p3CharName != null:
			match global.p3CharName:
				"BeardedMan":
					nameLabel.text = "Shayne"
				"Woman":
					nameLabel.text = "Angel"
		else:
			nameLabel.text = "Player 3"
	elif get_parent().name == "ViewportContainer4":
		player = 4
		if global.p4CharName != null:
			match global.p4CharName:
				"BeardedMan":
					nameLabel.text = "Shayne"
				"Woman":
					nameLabel.text = "Angel"
		else:
			nameLabel.text = "Player 4"

func updateHearts(life):
	if life == 6:
		heart1.texture = load("res://Images/UI/UI_HEART_FULL.png")
		heart2.texture = load("res://Images/UI/UI_HEART_FULL.png")
		heart3.texture = load("res://Images/UI/UI_HEART_FULL.png")
	elif life == 5: # Added elif for better structure
		heart1.texture = load("res://Images/UI/UI_HEART_FULL.png")
		heart2.texture = load("res://Images/UI/UI_HEART_FULL.png")
		heart3.texture = load("res://Images/UI/UI_HEART_HALF.png")
	elif life == 4:
		heart1.texture = load("res://Images/UI/UI_HEART_FULL.png")
		heart2.texture = load("res://Images/UI/UI_HEART_FULL.png")
		heart3.texture = load("res://Images/UI/UI_HEART_EMPTY.png")
	elif life == 3:
		heart1.texture = load("res://Images/UI/UI_HEART_FULL.png")
		heart2.texture = load("res://Images/UI/UI_HEART_HALF.png")
		heart3.texture = load("res://Images/UI/UI_HEART_EMPTY.png")
	elif life == 2:
		heart1.texture = load("res://Images/UI/UI_HEART_FULL.png")
		heart2.texture = load("res://Images/UI/UI_HEART_EMPTY.png")
		heart3.texture = load("res://Images/UI/UI_HEART_EMPTY.png")
	elif life == 1:
		heart1.texture = load("res://Images/UI/UI_HEART_HALF.png")
		heart2.texture = load("res://Images/UI/UI_HEART_EMPTY.png")
		heart3.texture = load("res://Images/UI/UI_HEART_EMPTY.png")
	elif life <= 0: # Changed to life <= 0 for robustness
		heart1.texture = load("res://Images/UI/UI_HEART_EMPTY.png")
		heart2.texture = load("res://Images/UI/UI_HEART_EMPTY.png")
		heart3.texture = load("res://Images/UI/UI_HEART_EMPTY.png")
