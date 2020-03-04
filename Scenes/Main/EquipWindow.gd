extends Sprite

var player
var weaponIcon
var armorIcon
onready var blankIcon = load("res//Scenes/Objects/Weapons/blank.png")
onready var stoneIcon = load("res://Scenes/Objects/Weapons/stone/stoneIcon.png")
onready var dartIcon = load("res://Scenes/Objects/Weapons/dart/dartIcon.png")
onready var boomerangIcon = load("res://Scenes/Objects/Weapons/boomerang/boomerangIcon.png")
onready var smokeBombIcon = load("res://Scenes/Objects/Weapons/smoke bomb/smokeBombIcon.png")
onready var woodbattleHammerIcon = load("res://Scenes/Objects/Weapons/wood battle hammer/woodenBattleHammerIcon.png")
onready var woodSwordIcon = load("res://Scenes/Objects/Weapons/wood sword/woodSwordIcon.png")
onready var woodenStickIcon = load("res://Scenes/Objects/Weapons/wooden stick/stickIcon.png")

func _process(delta):
	updateIcons()

func updateIcons():
	var weaponName
	if get_node("..").name == "UICanvasLayer1":
		player = 1
	elif get_node("..").name == "UICanvasLayer2":
		player = 2
	elif get_node("..").name == "UICanvasLayer3":
		player = 3
	elif get_node("..").name == "UICanvasLayer4":
		player = 4
	weaponIcon = $WeaponIcon
	armorIcon = $ArmorIcon
	match inventory.equipped(player, "weapon").name:
		"stone":
			weaponName = "stone"
			weaponIcon.texture = stoneIcon
		"dart":
			weaponName = "dart"
			weaponIcon.texture = dartIcon
		"wooden stick":
			weaponName = "wooden stick"
			weaponIcon.texture = woodenStickIcon
		"smoke bomb":
			weaponName = "smoke bomb"
			weaponIcon.texture = smokeBombIcon
		"boomerang":
			weaponName = "boomerang"
			weaponIcon.texture = boomerangIcon
		"wood battle hammer":
			weaponName = "wood battle hammer"
			weaponIcon.texture = woodbattleHammerIcon
		"wood sword":
			weaponName = "wood sword"
			weaponIcon.texture = woodSwordIcon
		_:
			weaponName = ""
			weaponIcon.texture = blankIcon
			
	if weaponName != "":
		var projAmount
		match player:
			1:
				projAmount = inventory.p1Inventory["weapon"][inventory.equipped(player, "weapon").name]
			2:
				projAmount = inventory.p2Inventory["weapon"][inventory.equipped(player, "weapon").name]
			3:
				projAmount = inventory.p3Inventory["weapon"][inventory.equipped(player, "weapon").name]
			4:
				projAmount = inventory.p4Inventory["weapon"][inventory.equipped(player, "weapon").name]
		$Weapon/Amount.text = "x " + str(projAmount)
	else:
		$Weapon/Amount.text = ""
		
		
		
		
		
		
		
		

