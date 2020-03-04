extends "res://Scenes/Characters/playerCharacters/playerBase.gd"

func _ready():
	meleeAttack = get_node("SpriteContainer/WomanMelee")
	meleeAttackAnimPlayer = get_node("SpriteContainer/WomanMelee/AnimationPlayer")
