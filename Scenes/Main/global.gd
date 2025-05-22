extends Node

var numOfPlayers = 1
var pauseGame = false
var p1CharName
var player1
var p1Life = 6
var p1Message # Global placeholder for wooden sign messages.
var p1InteractName # If message interaction uses nameplate.
var p2CharName
var player2
var p2Life = 6
var p2Message
var p2InteractName
var p3CharName
var player3
var p3Life = 6
var p3Message
var p3InteractName
var p4CharName
var player4
var p4Life = 6
var p4Message
var p4InteractName

var p1World
var p2World
var p3World
var p4World

var viewport1
var viewport2
var viewport3
var viewport4

var v1Message = false
var v2Message = false
var v3Message = false
var v4Message = false

var p1BoomerangThrown = false
var p2BoomerangThrown = false
var p3BoomerangThrown = false
var p4BoomerangThrown = false

func _ready():
	pass
	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

func positionCharacter(player_num, x, y): # Renamed 'player' to 'player_num' to avoid conflict
	if player_num == 1:
		if player1 != null: # Check if player1 node exists
			player1.position = Vector2(x, y)
	if player_num == 2 && player2 != null: # Removed 'global.' prefix
		player2.position = Vector2(x, y)
	if player_num == 3 && player3 != null: # Removed 'global.' prefix
		player3.position = Vector2(x, y)
	if player_num == 4 && player4 != null: # Removed 'global.' prefix
		player4.position = Vector2(x, y)
	pass # 'pass' is redundant here
	
func setViewportWorld(player_num, world): # Renamed 'player' to 'player_num'
	if player_num == 1:
		if viewport1 != null: viewport1.world_2d = world
	if player_num == 2:
		if viewport2 != null: viewport2.world_2d = world
	if player_num == 3:
		if viewport3 != null: viewport3.world_2d = world
	if player_num == 4:
		if viewport4 != null: viewport4.world_2d = world
	pass # 'pass' is redundant here
	
func distanceBetween(origin, target):
	return abs(origin.position.x - target.position.x)
	
func directionTowards(origin, target):
	if origin.position.x - target.position.x > 0:
		return -1
	# elif origin.position.x - target.position.x <= 0: # original
	else: # Simplified
		return 1
		
""" HELPER METHODS """
# Shift elements in an array DOESN'T WORK ATM (as per original comment)
func shiftArray(direction, arr: Array): # Added type hint for arr
	if arr.is_empty(): # Added check for empty array
		return arr

	var tempHolder
	if direction == "right":
		tempHolder = arr.pop_back()
		arr.push_front(tempHolder) 
	else:
		tempHolder = arr.pop_front()
		arr.push_back(tempHolder)
	return arr

# Pause a single node
func set_pause_node(node: Node, p_pause: bool):
	if p_pause:
		node.process_mode = Node.PROCESS_MODE_DISABLED
		node.physics_process_mode = Node.PROCESS_MODE_DISABLED
	else:
		node.process_mode = Node.PROCESS_MODE_INHERIT
		node.physics_process_mode = Node.PROCESS_MODE_INHERIT
