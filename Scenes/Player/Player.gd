extends Node2D

export (String, "Shayne", "Angel") var _name

onready var man = load("res://Scenes/Characters/playerCharacters/BeardedMan/beardedMan.tscn")
onready var woman = load("res://Scenes/Characters/playerCharacters/Woman/woman.tscn")
onready var pcharacter

func _ready():
	pass
	
func instanceCharacter(player):
	match _name:
		"Shayne":
			pcharacter = man.instance()
		"Angel":
			pcharacter = woman.instance()
	add_child(pcharacter)
	match player:
		"P1":
			global.p1CharName = pcharacter.name
			global.player1 = pcharacter
		"P2":
			global.p2CharName = pcharacter.name
			global.player2 = pcharacter
		"P3":
			global.p3CharName = pcharacter.name
			global.player3 = pcharacter
		"P4":
			global.p4CharName = pcharacter.name
			global.player4 = pcharacter
	
func _process(delta):
	var player = name
	match player:
		"P1":
			global.p1World = get_parent()
		"P2":
			global.p2World = get_parent()
		"P3":
			global.p3World = get_parent()
		"P4":
			global.p4World = get_parent()
	
