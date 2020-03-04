extends Node2D

func _ready():
	pass
	
func _process(delta):
	pass

func _on_house1Door_body_entered(body):
	match body.get_parent().name:
		"P1":
			global.player1.withinInteractableRange = true
			global.player1.objInteractedWith = "transition"
			global.player1.transitionTarget = [ get_tree().get_root().get_node("Control/World2Container"), 995, 960 ]
		"P2":
			global.player2.withinInteractableRange = true
			global.player2.objInteractedWith = "transition"
			global.player2.transitionTarget = [ get_tree().get_root().get_node("Control/World2Container"), 995, 960 ]
		"P3":
			global.player3.withinInteractableRange = true
			global.player3.objInteractedWith = "transition"
			global.player3.transitionTarget = [ get_tree().get_root().get_node("Control/World2Container"), 995, 960 ]
		"P4":
			global.player4.withinInteractableRange = true
			global.player4.objInteractedWith = "transition"
			global.player4.transitionTarget = [ get_tree().get_root().get_node("Control/World2Container"), 995, 960 ]


func _on_house1Door_body_exited(body):
	match body.get_parent().name:
		"P1":
			global.player1.withinInteractableRange = false
		"P2":
			global.player2.withinInteractableRange = false
		"P3":
			global.player3.withinInteractableRange = false
		"P4":
			global.player4.withinInteractableRange = false


func _on_sign1_body_entered(body):
	var message = "Welcome to Crist Chronicles. Newcomers, please enter!"
	match body.get_parent().name:
		"P1":
			global.player1.withinInteractableRange = true
			global.player1.objInteractedWith = "woodenSign"
			global.p1Message = message
		"P2":
			global.player2.withinInteractableRange = true
			global.player2.objInteractedWith = "woodenSign"
			global.p2Message = message
		"P3":
			global.player3.withinInteractableRange = true
			global.player3.objInteractedWith = "woodenSign"
			global.p3Message = message
		"P4":
			global.player4.withinInteractableRange = true
			global.player4.objInteractedWith = "woodenSign"
			global.p4Message = message


func _on_sign1_body_exited(body):
	match body.get_parent().name:
		"P1":
			global.player1.withinInteractableRange = false
			get_tree().get_root().get_node("Control/woodBack1").visible = false
		"P2":
			global.player2.withinInteractableRange = false
			get_tree().get_root().get_node("Control/woodBack2").visible = false
		"P3":
			global.player3.withinInteractableRange = false
			get_tree().get_root().get_node("Control/woodBack3").visible = false
		"P4":
			global.player4.withinInteractableRange = false
			get_tree().get_root().get_node("Control/woodBack4").visible = false

func _on_npc1_body_entered(body):
	var message = "Watch out for giant, horned spiders! They are quick and their horns are sharp. Also, if you are new here you should check out the newbie's guildhall. It's the first building here you'll come across. If you want my advice avoid going further until you've visted unless you already know how to survive. Ok, I've been rambling for long enough now. Time for you to go forward and write your story. It may be hard and there may be times you feel you want to give up but you musn't. You must fulfill your destiny and write your story for future adventurers to read!"
	var name = "SumRndmDude"
	match body.get_parent().name:
		"P1":
			global.player1.withinInteractableRange = true
			global.player1.objInteractedWith = "message"
			global.p1Message = message
			global.p1InteractName = name
		"P2":
			global.player2.withinInteractableRange = true
			global.player2.objInteractedWith = "message"
			global.p2Message = message
			global.p2InteractName = name
		"P3":
			global.player3.withinInteractableRange = true
			global.player3.objInteractedWith = "message"
			global.p3Message = message
			global.p3InteractName = name
		"P4":
			global.player4.withinInteractableRange = true
			global.player4.objInteractedWith = "message"
			global.p4Message = message
			global.p4InteractName = name

func _on_npc1_body_exited(body):
	match body.get_parent().name:
		"P1":
			global.player1.withinInteractableRange = false
			get_tree().get_root().get_node("Control/dialogBoxName1").visible = false
			get_tree().get_root().get_node("Control/dialogBoxName1").messageIndex = 0
		"P2":
			global.player2.withinInteractableRange = false
			get_tree().get_root().get_node("Control/dialogBoxName2").visible = false
			get_tree().get_root().get_node("Control/dialogBoxName2").messageIndex = 0
		"P3":
			global.player3.withinInteractableRange = false
			get_tree().get_root().get_node("Control/dialogBoxName3").visible = false
			get_tree().get_root().get_node("Control/dialogBoxName3").messageIndex = 0
		"P4":
			global.player4.withinInteractableRange = false
			get_tree().get_root().get_node("Control/dialogBoxName4").visible = false
			get_tree().get_root().get_node("Control/dialogBoxName4").messageIndex = 0
