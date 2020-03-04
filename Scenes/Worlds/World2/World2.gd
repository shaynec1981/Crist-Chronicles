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
			global.player1.transitionTarget = [ get_tree().get_root().get_node("Control/World1Container"), 1590, 960 ]
		"P2":
			global.player2.withinInteractableRange = true
			global.player2.objInteractedWith = "transition"
			global.player2.transitionTarget = [ get_tree().get_root().get_node("Control/World1Container"), 1590, 960 ]
		"P3":
			global.player3.withinInteractableRange = true
			global.player3.objInteractedWith = "transition"
			global.player3.transitionTarget = [ get_tree().get_root().get_node("Control/World1Container"), 1590, 960 ]
		"P4":
			global.player4.withinInteractableRange = true
			global.player4.objInteractedWith = "transition"
			global.player4.transitionTarget = [ get_tree().get_root().get_node("Control/World1Container"), 1590, 960 ]


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
