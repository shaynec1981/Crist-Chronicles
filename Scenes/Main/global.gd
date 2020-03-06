extends Node

var numOfPlayers = 1

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

func positionCharacter(player, x, y):
	if player == 1:
		player1.position = Vector2(x, y)
	if player == 2 && global.player2 != null:
		player2.position = Vector2(x, y)
	if player == 3 && global.player3 != null:
		player3.position = Vector2(x, y)
	if player == 4 && global.player4 != null:
		player4.position = Vector2(x, y)
	pass
	
func setViewportWorld(player, world):
	if player == 1:
		viewport1.world_2d = world
	if player == 2:
		viewport2.world_2d = world
	if player == 3:
		viewport3.world_2d = world
	if player == 4:
		viewport4.world_2d = world
	pass
	
func distanceBetween(origin, target):
	return abs(origin.position.x - target.position.x)
	
func directionTowards(origin, target):
	if origin.position.x - target.position.x > 0:
		return -1
	elif origin.position.x - target.position.x <= 0:
		return 1
		
""" HELPER METHODS """
# Shift elements in an array DOESN'T WORK ATM
func shiftArray(direction, arr):
	var tempHolder
	var origArr = arr
	if direction == "right":
		tempHolder = origArr.pop_back()
		return origArr.push_front(tempHolder)
	else:
		tempHolder = origArr.pop_front()
		return origArr.push_back(tempHolder)

# Pause a single node
func set_pause_node(node, pause):
	node.set_process(!pause)
	node.set_process_input(!pause)
	node.set_process_internal(!pause)
	node.set_process_unhandled_input(!pause)
	node.set_process_unhandled_key_input(!pause)
	node.set_physics_process(!pause)
		
		
		
		
