extends Node

onready var nameLabel = $HUD/NameLabel
onready var heart1 = $HUD/HeartsHBoxContainer/Heart1
onready var heart2 = $HUD/HeartsHBoxContainer/Heart2
onready var heart3 = $HUD/HeartsHBoxContainer/Heart3

var player
var playerLife = 6

func _ready():
	match global.numOfPlayers:
		1:
			if get_parent().name == "ViewportContainer2" || get_parent().name == "ViewportContainer3" || get_parent().name == "ViewportContainer4":
				get_node("HUD").visible = false
		2:
			if get_parent().name == "ViewportContainer3" || get_parent().name == "ViewportContainer4":
				get_node("HUD").visible = false
		3:
			if get_parent().name == "ViewportContainer4":
				get_node("HUD").visible = false
	
func _process(delta):
	if nameLabel.text == "Temp" && global.p1CharName != null:
		nameLabelsUpdate()
	
	# Life Check
	if nameLabel.text != "Temp":
		match player:
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
	if get_parent().name == "ViewportContainer1":
		player = 1
		match global.p1CharName:
			"BeardedMan":
				nameLabel.text = "Shayne"
			"Woman":
				nameLabel.text = "Angel"
	elif get_parent().name == "ViewportContainer2":
		player = 2
		match global.p2CharName:
			"BeardedMan":
				nameLabel.text = "Shayne"
			"Woman":
				nameLabel.text = "Angel"
	elif get_parent().name == "ViewportContainer3":
		player = 3
		match global.p3CharName:
			"BeardedMan":
				nameLabel.text = "Shayne"
			"Woman":
				nameLabel.text = "Angel"
	elif get_parent().name == "ViewportContainer4":
		player = 4
		match global.p4CharName:
			"BeardedMan":
				nameLabel.text = "Shayne"
			"Woman":
				nameLabel.text = "Angel"

func updateHearts(life):
	if life == 6:
		heart1.texture = load("res://Images/UI/UI_HEART_FULL.png")
		heart2.texture = load("res://Images/UI/UI_HEART_FULL.png")
		heart3.texture = load("res://Images/UI/UI_HEART_FULL.png")
	if life == 5:
		heart1.texture = load("res://Images/UI/UI_HEART_FULL.png")
		heart2.texture = load("res://Images/UI/UI_HEART_FULL.png")
		heart3.texture = load("res://Images/UI/UI_HEART_HALF.png")
	if life == 4:
		heart1.texture = load("res://Images/UI/UI_HEART_FULL.png")
		heart2.texture = load("res://Images/UI/UI_HEART_FULL.png")
		heart3.texture = load("res://Images/UI/UI_HEART_EMPTY.png")
	if life == 3:
		heart1.texture = load("res://Images/UI/UI_HEART_FULL.png")
		heart2.texture = load("res://Images/UI/UI_HEART_HALF.png")
		heart3.texture = load("res://Images/UI/UI_HEART_EMPTY.png")
	if life == 2:
		heart1.texture = load("res://Images/UI/UI_HEART_FULL.png")
		heart2.texture = load("res://Images/UI/UI_HEART_EMPTY.png")
		heart3.texture = load("res://Images/UI/UI_HEART_EMPTY.png")
	if life == 1:
		heart1.texture = load("res://Images/UI/UI_HEART_HALF.png")
		heart2.texture = load("res://Images/UI/UI_HEART_EMPTY.png")
		heart3.texture = load("res://Images/UI/UI_HEART_EMPTY.png")
	if life == 0:
		heart1.texture = load("res://Images/UI/UI_HEART_EMPTY.png")
		heart2.texture = load("res://Images/UI/UI_HEART_EMPTY.png")
		heart3.texture = load("res://Images/UI/UI_HEART_EMPTY.png")
