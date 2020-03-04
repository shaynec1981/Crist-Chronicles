extends Sprite

var bodies = 0

func _process(delta):
	pass

func _on_Area2D_body_entered(body):
	if bodies < 1:
		bodies += 1
		$Area2D.set_monitoring(false)
		body.health -= inventory.database["weapon"]["wooden stick"]["baseDmg"]
		body.isHit = true
		body.state = "gotHit"
		yield(get_tree().create_timer(0.25), "timeout")
		bodies = 0
