extends Node

var p1Inventory = {	"items": {},
					"weapon": {},
					"armor": {}}
var p1InventoryArray = [[],[],[]]
var p2Inventory = { "items": {},
					"weapon": {},
					"armor": {}}
var p2InventoryArray = [[],[],[]]
var p3Inventory = { "items": {},
					"weapon": {},
					"armor": {}}
var p3InventoryArray = [[],[],[]]
var p4Inventory = { "items": {},
					"weapon": {},
					"armor": {}}
var p4InventoryArray = [[],[],[]]
					
var p1Equipped = {"weapon": "", "armor": ""}
var p2Equipped = {"weapon": "", "armor": ""}
var p3Equipped = {"weapon": "", "armor": ""}
var p4Equipped = {"weapon": "", "armor": ""}
 
var database = {
	"items": {},
	"weapon": {},
	"armor": {}
}

func _ready():
	database["items"] = { "empty": { "name": "empty"},
		
	}
	database["weapon"] = {  "empty": { "name": "empty"},
							"stone": { "name" : "stone",
									 "scene": load("res://Scenes/Objects/Weapons/stone/stone.tscn"),
									 "icon": load("res://Scenes/Objects/Weapons/stone/stoneIcon50x50.png"),
									 "baseDmg": 1,
									 "value": 1,
									 "type": "projectile"},   
						   "dart": { "name" : "dart",
									 "scene": load("res://Scenes/Objects/Weapons/dart/dart.tscn"),
									 "icon": load("res://Scenes/Objects/Weapons/dart/dartIcon50x50.png"),
									 "baseDmg": 1.5,
									 "value": 2,
									 "type": "projectile"},
						   "wooden stick": { "name" : "wooden stick",
									 "scene": load("res://Scenes/Objects/Weapons/wooden stick/wooden stick.tscn"),
									 "icon": load("res://Scenes/Objects/Weapons/wooden stick/stickIcon50x50.png"),
									 "baseDmg": 1,
									 "value": 1,
									 "type": "melee"},
							"boomerang": { "name" : "boomerang",
									 "scene": load("res://Scenes/Objects/Weapons/boomerang/boomerang.tscn"),
									 "icon": load("res://Scenes/Objects/Weapons/boomerang/boomerang50x50.png"),
									 "baseDmg": 1,
									 "value": 1,
									 "type": "projectile"},
							"smoke bomb": { "name" : "smoke bomb",
									 "scene": load("res://Scenes/Objects/Weapons/smoke bomb/smoke bomb.tscn"),
									 "icon": load("res://Scenes/Objects/Weapons/smoke bomb/smokeBombIcon50x50.png"),
									 "baseDmg": 0,
									 "value": 1,
									 "type": "projectile"},
							"wood battle hammer": { "name" : "wood battle hammer",
									 "scene": load("res://Scenes/Objects/Weapons/wood battle hammer/wooden battle hammer.tscn"),
									 "icon": load("res://Scenes/Objects/Weapons/wood battle hammer/woodenBattleHammerIcon50x50.png"),
									 "baseDmg": 1.5,
									 "value": 1,
									 "type": "melee"},
							"wood sword": { "name" : "wood sword",
									 "scene": load("res://Scenes/Objects/Weapons/wood sword/wood sword.tscn"),
									 "icon": load("res://Scenes/Objects/Weapons/wood sword/woodSwordIcon50x50.png"),
									 "baseDmg": 2,
									 "value": 1,
									 "type": "melee"},
	}
	database["armor"] = { "empty": { "name": "empty"},
		
	}
	
func equipped(playerNumber, slot):
	var player
	match playerNumber:
		1:
			player = p1Equipped
		2:
			player = p2Equipped
		3:
			player = p3Equipped
		4:
			player = p4Equipped
	if player[slot] != "":
		return database[slot][player[slot]]
	else:
		return database[slot]["empty"]
	
func addItem(playerNumber, type, name, amount):
	var player
	var invArray
	var arrayTypeNumber
	match playerNumber:
		1:
			player = p1Inventory
			invArray= p1InventoryArray
		2:
			player = p2Inventory
			invArray= p2InventoryArray
		3:
			player = p3Inventory
			invArray= p3InventoryArray
		4:
			player = p4Inventory
			invArray= p4InventoryArray
	match type:
		"weapon":
			arrayTypeNumber = 0
		"armor":
			arrayTypeNumber = 1
		"item":
			arrayTypeNumber = 2
	if player[type].has(name):
		player[type][name] += amount
	else:
		player[type][name] = amount
		invArray[arrayTypeNumber].insert(invArray[arrayTypeNumber].size(), name)
		
func removeItem(playerNumber, type, item):
	match playerNumber:
		1:
			print("remove " + item)
		2:
			pass
		3:
			pass
		4:
			pass
	
func equipWeapon(playerNumber, weapon):
	var player = playerNumber
	match player:
		1:
			if p1Inventory["weapon"].has(weapon):
				p1Equipped["weapon"] = weapon
				#global.player1.spawnWeapon(weapon)
		2:
			if p2Inventory["weapon"].has(weapon):
				p2Equipped["weapon"] = weapon
				#global.player1.spawnWeapon(weapon)
		3:
			if p3Inventory["weapon"].has(weapon):
				p3Equipped["weapon"] = weapon
				#global.player1.spawnWeapon(weapon)
		4:
			if p4Inventory["weapon"].has(weapon):
				p4Equipped["weapon"] = weapon
				#global.player1.spawnWeapon(weapon)
	
func unequipWeapon(playerNumber, weapon):
	var player
	
func equipArmor(playerNumber, armor):
	var player
	
func unequipArmor(playerNumber, armor):
	var player
	
func useItem(playerNumber, item, target = "self"):
	var player
	
func numOfItems(playerNumber, item):
	pass
	
func numOfWeapons(playerNumber, weapon):
	match playerNumber:
		1:
			if p1Inventory["weapon"].has(weapon):
				return p1Inventory["weapon"][weapon]
		2:
			if p2Inventory["weapon"].has(weapon):
				return p2Inventory["weapon"][weapon]
		3:
			if p3Inventory["weapon"].has(weapon):
				return p3Inventory["weapon"][weapon]
		4:
			if p4Inventory["weapon"].has(weapon):
				return p4Inventory["weapon"][weapon]
	
func numOfArmor(playerNumber, armor):
	pass
	
	
	
	
	
	
	
	
	
	
	
