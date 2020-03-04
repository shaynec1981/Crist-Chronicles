extends RigidBody2D

onready var randomVelocity = Vector2()

var player

func _ready():
	pass
	
func determinePlayer(curPlayer):
	player = curPlayer
	throw()
	
func throw():
	randomVelocity.x = get_linear_velocity().x + randi() % 201 + 1
	randomVelocity.y = get_linear_velocity().y - randi() % 61 + 1
	match player:
		1:
			if global.player1.facingDirection == "left":
				$Sprite.set_flip_h(true)
				$CollisionPolygon2D.scale.x = -1
				set_linear_velocity(Vector2(-randomVelocity.x, randomVelocity.y))
				set_position(Vector2(global.player1.position.x - 50, global.player1.position.y))
			elif global.player1.facingDirection == "right":
				set_position(Vector2(global.player1.position.x + 50, global.player1.position.y))
				set_linear_velocity(randomVelocity)
		2:
			if global.player2.facingDirection == "left":
				$Sprite.set_flip_h(true)
				$CollisionPolygon2D.scale.x = -1
				set_linear_velocity(Vector2(-randomVelocity.x, randomVelocity.y))
				set_position(Vector2(global.player2.position.x - 50, global.player2.position.y))
			elif global.player2.facingDirection == "right":
				set_position(Vector2(global.player2.position.x + 50, global.player2.position.y))
				set_linear_velocity(randomVelocity)
		3:
			if global.player3.facingDirection == "left":
				$Sprite.set_flip_h(true)
				$CollisionPolygon2D.scale.x = -1
				set_linear_velocity(Vector2(-randomVelocity.x, randomVelocity.y))
				set_position(Vector2(global.player3.position.x - 50, global.player3.position.y))
			elif global.player3.facingDirection == "right":
				set_position(Vector2(global.player3.position.x + 50, global.player3.position.y))
				set_linear_velocity(randomVelocity)
		4:
			if global.player4.facingDirection == "left":
				$Sprite.set_flip_h(true)
				$CollisionPolygon2D.scale.x = -1
				set_linear_velocity(Vector2(-randomVelocity.x, randomVelocity.y))
				set_position(Vector2(global.player4.position.x - 50, global.player4.position.y))
			elif global.player4.facingDirection == "right":
				set_position(Vector2(global.player4.position.x + 50, global.player4.position.y))
				set_linear_velocity(randomVelocity)
				
func _on_Timer_timeout():
	queue_free()

func _on_stone_body_entered(body):
	if body.get_parent().name == "Enemies":
		body.health -= inventory.database["weapon"]["stone"]["baseDmg"]
		set_max_contacts_reported(0)
		body.isHit = true
		body.state = "gotHit"
	else:
		set_max_contacts_reported(0)
		
func _process(delta):
	pass
