extends Node2D

onready var _player = $AudioStreamPlayer
onready var _cursor = $numOfPlayersText/Particles2D
onready var timer = $Timer1
onready var titleText = $titleText
onready var animationPlayer = $AnimationPlayer

var track = load("res://Audio/Music/Aether3.ogg")
var numOfPlayersIndex = 1
var lastIndex = 1

func _ready():
	_player.stream = track
	_player.play()
	$numOfPlayersText/numOfPlayers1Text.self_modulate = Color(255, 255, 255, 255)
	
func _process(delta):
	if get_node("numOfPlayersText").visible == true && (Input.is_action_just_pressed("p1Right") || Input.is_action_just_pressed("p2Right")):
		if numOfPlayersIndex != 4:
			numOfPlayersIndex += 1
		else:
			numOfPlayersIndex = 1
	if get_node("numOfPlayersText").visible == true && (Input.is_action_just_pressed("p1Left") || Input.is_action_just_pressed("p2Left")):
		if numOfPlayersIndex != 1:
			numOfPlayersIndex -= 1
		else:
			numOfPlayersIndex = 4
	if lastIndex != numOfPlayersIndex:
		$numOfPlayersText/numOfPlayers1Text.self_modulate = Color(1, 1, 1, 1)
		$numOfPlayersText/numOfPlayers2Text.self_modulate = Color(1, 1, 1, 1)
		$numOfPlayersText/numOfPlayers3Text.self_modulate = Color(1, 1, 1, 1)
		$numOfPlayersText/numOfPlayers4Text.self_modulate = Color(1, 1, 1, 1)
		match numOfPlayersIndex:
			1:
				_cursor.position.x = -60
				$numOfPlayersText/numOfPlayers1Text.self_modulate = Color(255, 255, 255, 255)
				global.numOfPlayers = 1
			2:
				_cursor.position.x = -10
				$numOfPlayersText/numOfPlayers2Text.self_modulate = Color(255, 255, 255, 255)
				global.numOfPlayers = 2
			3:
				_cursor.position.x = 40
				$numOfPlayersText/numOfPlayers3Text.self_modulate = Color(255, 255, 255, 255)
				global.numOfPlayers = 3
			4:
				_cursor.position.x = 90
				$numOfPlayersText/numOfPlayers4Text.self_modulate = Color(255, 255, 255, 255)
				global.numOfPlayers = 4
		lastIndex = numOfPlayersIndex
				
	if get_node("numOfPlayersText").visible == true && Input.is_action_just_pressed("p1Start"):
		get_tree().change_scene("res://Scenes/Main/Splitscreen.tscn")
	if get_node("numOfPlayersText").visible == false && Input.is_action_just_pressed("p1Start"):
		timer.stop()
		animationPlayer.stop()
		titleText.position.x = 960
		showTitleText()
		
func _on_Timer1_timeout():
	$AnimationPlayer.play("titleIn")
	
func showTitleText():
	get_node("numOfPlayersText").visible = true
	get_node("PressStartTo").visible = true
