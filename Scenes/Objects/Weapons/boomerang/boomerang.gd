extends RigidBody2D

onready var randomVelocity = Vector2()

var playerNum
var player
var bReturn = false
var returnTarget = Vector2()
var returnSpeed = 200
var velocity = Vector2()
var acceleration = Vector2()

func _ready():
	pass
	

func determinePlayer(curPlayer):
	playerNum = curPlayer
	throw()
	
func throw():
	randomVelocity.x = get_linear_velocity().x + randi() % 201 + 1
	randomVelocity.y = get_linear_velocity().y - randi() % 61 + 1
	match playerNum:
		1:
			if global.player1.facingDirection == "left":
				$Sprite.set_flip_h(true)
				$CollisionShape2D.scale.x = -1
				set_linear_velocity(Vector2(-randomVelocity.x, randomVelocity.y))
				set_position(Vector2(global.player1.position.x - 50, global.player1.position.y))
				global.p1BoomerangThrown = true
			elif global.player1.facingDirection == "right":
				set_position(Vector2(global.player1.position.x + 50, global.player1.position.y))
				set_linear_velocity(randomVelocity)
				global.p1BoomerangThrown = true
			player = get_parent().get_node("P1/" + global.p1CharName)
		2:
			if global.player2.facingDirection == "left":
				$Sprite.set_flip_h(true)
				$CollisionShape2D.scale.x = -1
				set_linear_velocity(Vector2(-randomVelocity.x, randomVelocity.y))
				set_position(Vector2(global.player2.position.x - 50, global.player2.position.y))
				global.p2BoomerangThrown = true
			elif global.player2.facingDirection == "right":
				set_position(Vector2(global.player2.position.x + 50, global.player2.position.y))
				set_linear_velocity(randomVelocity)
				global.p2BoomerangThrown = true
			player = get_parent().get_node("P2/" + global.p2CharName)
		3:
			if global.player3.facingDirection == "left":
				$Sprite.set_flip_h(true)
				$CollisionShape2D.scale.x = -1
				set_linear_velocity(Vector2(-randomVelocity.x, randomVelocity.y))
				set_position(Vector2(global.player3.position.x - 50, global.player3.position.y))
				global.p3BoomerangThrown = true
			elif global.player3.facingDirection == "right":
				set_position(Vector2(global.player3.position.x + 50, global.player3.position.y))
				set_linear_velocity(randomVelocity)
				global.p3BoomerangThrown = true
			player = get_parent().get_node("P3/" + global.p3CharName)
		4:
			if global.player4.facingDirection == "left":
				$Sprite.set_flip_h(true)
				$CollisionShape2D.scale.x = -1
				set_linear_velocity(Vector2(-randomVelocity.x, randomVelocity.y))
				set_position(Vector2(global.player4.position.x - 50, global.player4.position.y))
				global.p4BoomerangThrown = true
			elif global.player4.facingDirection == "right":
				set_position(Vector2(global.player4.position.x + 50, global.player4.position.y))
				set_linear_velocity(randomVelocity)
				global.p4BoomerangThrown = true
			player = get_parent().get_node("P4/" + global.p4CharName)
			
func _on_boomerang_body_entered(body):
	print(body)
	if body.get_parent().name == "Enemies":
		body.health -= inventory.database["weapon"]["dart"]["baseDmg"]
		set_max_contacts_reported(0)
		body.isHit = true
		body.state = "gotHit"
	bReturn = true
		
func _physics_process(delta):
	if global.distanceBetween(self, player) >= 500:
		bReturn = true
		
func _integrate_forces(state):
	if bReturn:
		returnTarget = player.position
		var direction = (player.global_position - global_position).normalized()
		var distanceToPlayer = global_position.distance_to(player.global_position)
		if distanceToPlayer > 100:
			if direction.y >= -0.15:
				apply_central_impulse(Vector2(direction.x * 100, 0))
			else:
				apply_central_impulse(Vector2(direction.x * 100, direction.y * 1000))
		else:
			match playerNum:
				1:
					global.p1BoomerangThrown = false
				2:
					global.p2BoomerangThrown = false
				3:
					global.p3BoomerangThrown = false
				4:
					global.p4BoomerangThrown = false
			queue_free()
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
		
