extends Control

onready var viewport1 = $VBoxContainer/HBoxContainer/ViewportContainer1/Viewport1
onready var viewport2 = $VBoxContainer/HBoxContainer/ViewportContainer2/Viewport2
onready var viewport3 = $VBoxContainer/HBoxContainer2/ViewportContainer3/Viewport3
onready var viewport4 = $VBoxContainer/HBoxContainer2/ViewportContainer4/Viewport4
onready var camera1 = $VBoxContainer/HBoxContainer/ViewportContainer1/Viewport1/Camera2D
onready var camera2 = $VBoxContainer/HBoxContainer/ViewportContainer2/Viewport2/Camera2D
onready var camera3 = $VBoxContainer/HBoxContainer2/ViewportContainer3/Viewport3/Camera2D
onready var camera4 = $VBoxContainer/HBoxContainer2/ViewportContainer4/Viewport4/Camera2D
onready var player1 = $World1Container/P1
onready var player2 = $World1Container/P2
onready var player3 = $World1Container/P3
onready var player4 = $World1Container/P4
onready var woodenSign1 = $woodBack1
onready var woodenSign2 = $woodBack2
onready var woodenSign3 = $woodBack3
onready var woodenSign4 = $woodBack4
onready var dialogBox1 = $dialogBoxName1
onready var dialogBox2 = $dialogBoxName2
onready var dialogBox3 = $dialogBoxName3
onready var dialogBox4 = $dialogBoxName4
onready var inventoryWindow1 = $VBoxContainer/HBoxContainer/ViewportContainer1/UICanvasLayer1/InventoryWindow
onready var inventoryWindow2 = $VBoxContainer/HBoxContainer/ViewportContainer2/UICanvasLayer2/InventoryWindow2
onready var inventoryWindow3 = $VBoxContainer/HBoxContainer2/ViewportContainer3/UICanvasLayer3/InventoryWindow3
onready var inventoryWindow4 = $VBoxContainer/HBoxContainer2/ViewportContainer4/UICanvasLayer4/InventoryWindow4
onready var equipWindow1 = $VBoxContainer/HBoxContainer/ViewportContainer1/UICanvasLayer1/EquipWindow
onready var equipWindow2 = $VBoxContainer/HBoxContainer/ViewportContainer2/UICanvasLayer2/EquipWindow
onready var equipWindow3 = $VBoxContainer/HBoxContainer2/ViewportContainer3/UICanvasLayer3/EquipWindow
onready var equipWindow4 = $VBoxContainer/HBoxContainer2/ViewportContainer4/UICanvasLayer4/EquipWindow

func _ready():
	# Check for controller
	Input.connect("joy_connection_changed", self, "_on_joy_connection_changed")
	global.viewport1 = $VBoxContainer/HBoxContainer/ViewportContainer1/Viewport1
	global.viewport2 = $VBoxContainer/HBoxContainer/ViewportContainer2/Viewport2
	global.viewport3 = $VBoxContainer/HBoxContainer2/ViewportContainer3/Viewport3
	global.viewport4 = $VBoxContainer/HBoxContainer2/ViewportContainer4/Viewport4
	
	# Set up viewports according to how many players start the game.
	match global.numOfPlayers:
		1:
			global.set_pause_node(player2, true)
			global.set_pause_node(player3, true)
			global.set_pause_node(player4, true)
			$VBoxContainer/HBoxContainer/ViewportContainer1/UICanvasLayer1/EquipWindow.position.x = ($VBoxContainer/HBoxContainer/ViewportContainer1/UICanvasLayer1/EquipWindow.position.x * 2) + 130
			get_node("VBoxContainer/HBoxContainer/ViewportContainer2").visible = false
			get_node("VBoxContainer/HBoxContainer2/ViewportContainer3").visible = false
			get_node("VBoxContainer/HBoxContainer2/ViewportContainer4").visible = false
			get_node("VBoxContainer/HBoxContainer2").visible = false
			$World1Container.remove_child($World1Container/P2)
			global.p2World = null
			$World1Container.remove_child($World1Container/P3)
			global.p3World = null
			$World1Container.remove_child($World1Container/P4)
			global.p4World = null
			woodenSign1.position = Vector2(960, 550)
			woodenSign1.scale = Vector2(2, 2)
			dialogBox1.position = Vector2(960, 500)
			dialogBox1.scale = Vector2(2, 2)
			equipWindow2.visible = false
			equipWindow3.visible = false
			equipWindow4.visible = false
		2:
			global.set_pause_node(player3, true)
			global.set_pause_node(player4, true)
			get_node("VBoxContainer/HBoxContainer2/ViewportContainer3").visible = false
			get_node("VBoxContainer/HBoxContainer2/ViewportContainer4").visible = false
			get_node("VBoxContainer/HBoxContainer2").visible = false
			camera1.zoom = Vector2(1.0, 1.0)
			camera2.zoom = Vector2(1.0, 1.0)
			$World1Container.remove_child($World1Container/P3)
			global.p3World = null
			$World1Container.remove_child($World1Container/P4)
			global.p4World = null
			woodenSign1.position = Vector2(470, 655)
			woodenSign1.scale = Vector2(1.5, 1.5)
			woodenSign2.position = Vector2(1460, 655)
			woodenSign2.scale = Vector2(1.5, 1.5)
			dialogBox1.position = Vector2(480, 580)
			dialogBox1.scale = Vector2(1.5, 1.5)
			dialogBox2.position = Vector2(1440, 580)
			dialogBox2.scale = Vector2(1.5, 1.5)
			inventoryWindow1.position.x = 480
			inventoryWindow1.scale = Vector2(1.25, 1.25)
			inventoryWindow2.position.x = 1440
			inventoryWindow2.scale = Vector2(1.25, 1.25)
			equipWindow3.visible = false
			equipWindow4.visible = false
		3:
			global.set_pause_node(player4, true)
			get_node("VBoxContainer/HBoxContainer2/ViewportContainer4").visible = false
			camera1.zoom = Vector2(1.25, 1.25)
			camera2.zoom = Vector2(1.25, 1.25)
			camera3.zoom = Vector2(1.25, 1.25)
			$World1Container.remove_child($World1Container/P4)
			global.p4World = null
			woodenSign1.position = Vector2(470, 240)
			woodenSign1.scale = Vector2(1, 1)
			woodenSign2.position = Vector2(1460, 240)
			woodenSign2.scale = Vector2(1, 1)
			woodenSign3.position = Vector2(960, 785)
			woodenSign3.scale = Vector2(1.5, 1.5)
			dialogBox1.position = Vector2(480, 230)
			dialogBox1.scale = Vector2(1, 1)
			dialogBox2.position = Vector2(1440, 230)
			dialogBox2.scale = Vector2(1, 1)
			dialogBox3.position = Vector2(960, 785)
			dialogBox3.scale = Vector2(1.5, 1.5)
			inventoryWindow1.position.x = 480
			inventoryWindow1.position.y = 230
			inventoryWindow1.scale = Vector2(0.75, 0.75)
			inventoryWindow2.position.x = 1440
			inventoryWindow2.position.y = 230
			inventoryWindow2.scale = Vector2(0.75, 0.75)
			inventoryWindow3.position.x = 960
			inventoryWindow3.position.y = 770
			inventoryWindow3.scale = Vector2(0.75, 0.75)
			equipWindow3.position.x = 1795
			equipWindow4.visible = false
		4:
			camera1.zoom = Vector2(1.25, 1.25)
			camera2.zoom = Vector2(1.25, 1.25)
			camera3.zoom = Vector2(1.25, 1.25)
			camera4.zoom = Vector2(1.25, 1.25)
			woodenSign1.position = Vector2(470, 240)
			woodenSign1.scale = Vector2(1, 1)
			woodenSign2.position = Vector2(1460, 240)
			woodenSign2.scale = Vector2(1, 1)
			woodenSign3.position = Vector2(470, 785)
			woodenSign3.scale = Vector2(1, 1)
			woodenSign4.position = Vector2(1460, 785)
			woodenSign4.scale = Vector2(1, 1)
			dialogBox1.position = Vector2(480, 230)
			dialogBox1.scale = Vector2(1, 1)
			dialogBox2.position = Vector2(1440, 230)
			dialogBox2.scale = Vector2(1, 1)
			dialogBox3.position = Vector2(480, 785)
			dialogBox3.scale = Vector2(1, 1)
			dialogBox4.position = Vector2(1440, 785)
			dialogBox4.scale = Vector2(1, 1)
			inventoryWindow1.position.x = 480
			inventoryWindow1.position.y = 230
			inventoryWindow1.scale = Vector2(0.75, 0.75)
			inventoryWindow2.position.x = 1440
			inventoryWindow2.position.y = 230
			inventoryWindow2.scale = Vector2(0.75, 0.75)
			inventoryWindow3.position.x = 480
			inventoryWindow3.position.y = 770
			inventoryWindow3.scale = Vector2(0.75, 0.75)
			inventoryWindow4.position.x = 1440
			inventoryWindow4.position.y = 770
			inventoryWindow4.scale = Vector2(0.75, 0.75)
		_:
			print("Something is wrong with the number of players. *Splitscreen.gd Ln 149*")
			
	if global.numOfPlayers >= 1:
		global.setViewportWorld(1, $World1Container.world_2d)
		player1.instanceCharacter("P1")
		global.positionCharacter(1, 350, 900)
		camera1.target = $World1Container/P1.get_node(global.p1CharName)
	if global.numOfPlayers > 1:
		global.setViewportWorld(2, $World1Container.world_2d)
		player2.instanceCharacter("P2")
		global.positionCharacter(2, 300, 950)
		camera2.target = $World1Container/P2.get_node(global.p2CharName)
	if global.numOfPlayers > 2:
		global.setViewportWorld(3, $World1Container.world_2d)
		player3.instanceCharacter("P3")
		global.positionCharacter(3, 500, 950)
		camera3.target = $World1Container/P3.get_node(global.p3CharName)
	if global.numOfPlayers > 3:
		global.setViewportWorld(4, $World1Container.world_2d)
		player4.instanceCharacter("P4")
		global.positionCharacter(4, 700, 950)
		camera4.target = $World1Container/P4.get_node(global.p4CharName)
	
func _on_joy_connection_changed(device_id, connected):
	if connected:
		print(Input.get_joy_name(device_id))
	else:
		print("Keyboard")

func _process(delta):
	pass
	
func _physics_process(delta):
	if !global.pauseGame:
		# Player 1 Controls
		if Input.is_action_pressed("p1Right"):
			global.player1.playerControls("right")
		elif Input.is_action_pressed("p1Left"):
			global.player1.playerControls("left")
		elif global.player1.state != "gotHit":
			global.player1.state = "idle"
			global.player1.motion.x = lerp(global.player1.motion.x, 0, 0.2)
			global.player1.get_node("AnimationPlayer").play("idle")
		
		if Input.is_action_just_pressed("p1Up"):
			global.player1.playerControls("up")
		
		if Input.is_action_just_pressed("p1Down"):
			global.player1.playerControls("down")
		
		if Input.is_action_just_pressed("p1Jump"):
			global.player1.playerControls("jump")
			
		if Input.is_action_just_pressed("p1Interact"):
			global.player1.playerControls("interact")
			
		if Input.is_action_just_pressed("p1LeftBumper"):
			global.player1.playerControls("lBumper")
			
		if Input.is_action_just_pressed("p1RightBumper"):
			global.player1.playerControls("rBumper")
			
		if Input.is_action_just_pressed("p1Menu"):
			global.player1.playerControls("inventory")
		
		if global.numOfPlayers > 1:
			# Player 2 Controls
			if Input.is_action_pressed("p2Right"):
				global.player2.playerControls("right")
			elif Input.is_action_pressed("p2Left"):
				global.player2.playerControls("left")
			elif global.player2.state != "gotHit":
				global.player2.state = "idle"
				global.player2.motion.x = lerp(global.player2.motion.x, 0, 0.2)
				global.player2.get_node("AnimationPlayer").play("idle")
				
			if Input.is_action_just_pressed("p2Up"):
				global.player2.playerControls("up")
		
			if Input.is_action_just_pressed("p2Down"):
				global.player2.playerControls("down")
			
			if Input.is_action_just_pressed("p2Jump"):
				global.player2.playerControls("jump")
			
			if Input.is_action_just_pressed("p2Interact"):
				global.player2.playerControls("interact")
				
			if Input.is_action_just_pressed("p2LeftBumper"):
				global.player2.playerControls("lBumper")
			
			if Input.is_action_just_pressed("p2RightBumper"):
				global.player2.playerControls("rBumper")
				
			if Input.is_action_just_pressed("p2Menu"):
				global.player2.playerControls("inventory")
			
		if global.numOfPlayers > 2:
			# Player 3 Controls
			if Input.is_action_pressed("p3Right"):
				global.player3.playerControls("right")
			elif Input.is_action_pressed("p3Left"):
				global.player3.playerControls("left")
			elif global.player3.state != "gotHit":
				global.player3.state = "idle"
				global.player3.motion.x = lerp(global.player3.motion.x, 0, 0.2)
				global.player3.get_node("AnimationPlayer").play("idle")
			
			if Input.is_action_just_pressed("p3Jump"):
				global.player3.playerControls("jump")
				
			if Input.is_action_just_pressed("p3Up"):
				global.player3.playerControls("up")
		
			if Input.is_action_just_pressed("p3Down"):
				global.player3.playerControls("down")
			
			if Input.is_action_just_pressed("p3Interact"):
				global.player3.playerControls("interact")
				
			if Input.is_action_just_pressed("p3LeftBumper"):
				global.player3.playerControls("lBumper")
			
			if Input.is_action_just_pressed("p3RightBumper"):
				global.player3.playerControls("rBumper")
				
			if Input.is_action_just_pressed("p3Menu"):
				global.player3.playerControls("inventory")
			
		if global.numOfPlayers > 3:
			# Player 4 Controls
			if Input.is_action_pressed("p4Right"):
				global.player4.playerControls("right")
			elif Input.is_action_pressed("p4Left"):
				global.player4.playerControls("left")
			elif global.player4.state != "gotHit":
				global.player4.state = "idle"
				global.player4.motion.x = lerp(global.player4.motion.x, 0, 0.2)
				global.player4.get_node("AnimationPlayer").play("idle")
			
			if Input.is_action_just_pressed("p4Jump"):
				global.player4.playerControls("jump")
				
			if Input.is_action_just_pressed("p4Up"):
				global.player4.playerControls("up")
		
			if Input.is_action_just_pressed("p4Down"):
				global.player4.playerControls("down")
			
			if Input.is_action_just_pressed("p4Interact"):
				global.player4.playerControls("interact")
		
			if Input.is_action_just_pressed("p4LeftBumper"):
				global.player4.playerControls("lBumper")
			
			if Input.is_action_just_pressed("p4RightBumper"):
				global.player4.playerControls("rBumper")
				
			if Input.is_action_just_pressed("p4Menu"):
				global.player4.playerControls("inventory")
