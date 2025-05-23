extends Node2D

@onready var _player: AudioStreamPlayer = $AudioStreamPlayer # Added type hint
@onready var _cursor = $numOfPlayersText/Particles2D
@onready var timer: Timer = $Timer1 # Changed from 'timer' to 'timer1' based on path, and added type hint
@onready var titleText = $titleText
@onready var animationPlayer: AnimationPlayer = $AnimationPlayer # Added type hint

# Added @onready vars for frequently accessed nodes
@onready var num_of_players_text_node = $numOfPlayersText # 3. @onready var
@onready var press_start_to_node = $PressStartTo     # 3. @onready var

# Specific text nodes for modulation
@onready var num_players_1_text = $numOfPlayersText/numOfPlayers1Text
@onready var num_players_2_text = $numOfPlayersText/numOfPlayers2Text
@onready var num_players_3_text = $numOfPlayersText/numOfPlayers3Text
@onready var num_players_4_text = $numOfPlayersText/numOfPlayers4Text


var track = load("res://Audio/Music/Aether3.ogg")
var numOfPlayersIndex = 1
var lastIndex = 1

func _ready():
	_player.stream = track
	_player.play()
	# 2. Correct Color constructor
	num_players_1_text.self_modulate = Color(1.0, 1.0, 1.0, 1.0) 
	
func _process(delta):
	# Use @onready var for num_of_players_text_node
	if num_of_players_text_node.visible == true && (Input.is_action_just_pressed("p1Right") || Input.is_action_just_pressed("p2Right")):
		if numOfPlayersIndex != 4:
			numOfPlayersIndex += 1
		else:
			numOfPlayersIndex = 1
	if num_of_players_text_node.visible == true && (Input.is_action_just_pressed("p1Left") || Input.is_action_just_pressed("p2Left")):
		if numOfPlayersIndex != 1:
			numOfPlayersIndex -= 1
		else:
			numOfPlayersIndex = 4
			
	if lastIndex != numOfPlayersIndex:
		# Reset all to non-highlighted (Godot 4 Color(1,1,1,1) is opaque white)
		num_players_1_text.self_modulate = Color(1.0, 1.0, 1.0, 0.5) # Example: slightly transparent for non-selected
		num_players_2_text.self_modulate = Color(1.0, 1.0, 1.0, 0.5)
		num_players_3_text.self_modulate = Color(1.0, 1.0, 1.0, 0.5)
		num_players_4_text.self_modulate = Color(1.0, 1.0, 1.0, 0.5)
		
		match numOfPlayersIndex:
			1:
				_cursor.position.x = -60
				num_players_1_text.self_modulate = Color(1.0, 1.0, 1.0, 1.0) # Opaque white for selected
				global.numOfPlayers = 1
			2:
				_cursor.position.x = -10
				num_players_2_text.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
				global.numOfPlayers = 2
			3:
				_cursor.position.x = 40
				num_players_3_text.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
				global.numOfPlayers = 3
			4:
				_cursor.position.x = 90
				num_players_4_text.self_modulate = Color(1.0, 1.0, 1.0, 1.0)
				global.numOfPlayers = 4
		lastIndex = numOfPlayersIndex
				
	if num_of_players_text_node.visible == true && Input.is_action_just_pressed("p1Start"):
		# 4. Change scene to file
		get_tree().change_scene_to_file("res://Scenes/Main/Splitscreen.tscn")
	if num_of_players_text_node.visible == false && Input.is_action_just_pressed("p1Start"):
		timer.stop() # 5. Timer stop is compatible
		animationPlayer.stop() # 5. AnimationPlayer stop is compatible
		titleText.position.x = 960 # Assuming this is a valid position reset
		showTitleText()
		
func _on_Timer1_timeout(): # Assuming Timer1 is the correct name for 'timer'
	animationPlayer.play("titleIn") # 5. AnimationPlayer play is compatible
	
func showTitleText():
	# Use @onready vars
	num_of_players_text_node.visible = true
	press_start_to_node.visible = true
