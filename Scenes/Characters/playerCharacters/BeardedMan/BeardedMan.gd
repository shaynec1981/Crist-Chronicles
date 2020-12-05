extends "res://Scenes/Characters/playerCharacters/playerBase.gd"

func _ready():
	meleeAttack = get_node("SpriteContainer/BearedManMelee")
	meleeAttackAnimPlayer = get_node("SpriteContainer/BearedManMelee/AnimationPlayer")
	
func spawnWeapon(weapon):
	pass


