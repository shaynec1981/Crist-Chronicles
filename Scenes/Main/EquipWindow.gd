extends Sprite # 3. Acknowledged: Unusual base class for a UI window.

var player # Determined by parent node name

# 2. Initialize UI nodes with @onready var
@onready var weaponIcon = $WeaponIcon 
@onready var armorIcon = $ArmorIcon
@onready var weaponAmountLabel = $Weapon/Amount # Assuming this is a Label node

# 1. Replace onready var for icon loading with @onready var and correct paths
@onready var blankIcon: Texture = load("res://Scenes/Objects/Weapons/blank.png") # Corrected path and added type hint
@onready var stoneIcon: Texture = load("res://Scenes/Objects/Weapons/stone/stoneIcon.png")
@onready var dartIcon: Texture = load("res://Scenes/Objects/Weapons/dart/dartIcon.png")
@onready var boomerangIcon: Texture = load("res://Scenes/Objects/Weapons/boomerang/boomerangIcon.png")
@onready var smokeBombIcon: Texture = load("res://Scenes/Objects/Weapons/smoke bomb/smokeBombIcon.png")
@onready var woodbattleHammerIcon: Texture = load("res://Scenes/Objects/Weapons/wood battle hammer/woodenBattleHammerIcon.png")
@onready var woodSwordIcon: Texture = load("res://Scenes/Objects/Weapons/wood sword/woodSwordIcon.png")
@onready var woodenStickIcon: Texture = load("res://Scenes/Objects/Weapons/wooden stick/stickIcon.png")

func _process(delta): # Called every frame
	updateIcons()

func updateIcons():
	var weaponName # To store the name of the equipped weapon

	# 4. Fragile logic to determine player based on parent node's name. Left as is per instructions.
	var parent_name = get_parent().name
	if parent_name == "UICanvasLayer1": # Using direct string comparison
		player = 1
	elif parent_name == "UICanvasLayer2":
		player = 2
	elif parent_name == "UICanvasLayer3":
		player = 3
	elif parent_name == "UICanvasLayer4":
		player = 4
	else:
		player = null # Player could not be determined

	if player == null:
		weaponIcon.texture = blankIcon # Default if player not determined
		armorIcon.texture = blankIcon # Assuming similar logic for armor
		weaponAmountLabel.text = ""
		return

	# UI nodes are now class members initialized with @onready, no need to get_node here.
	# weaponIcon = $WeaponIcon (Removed)
	# armorIcon = $ArmorIcon (Removed)

	# 5. Match statement and .texture assignment (compatible)
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
		_: # Default case for empty or unknown weapon
			weaponName = ""
			weaponIcon.texture = blankIcon
			
	# Update weapon amount label
	if weaponName != "":
		var projAmount = 0 # Default to 0
		# Accessing specific player inventory, ensure 'inventory' autoload is robust.
		var player_inventory_weapon_map = inventory.get("p" + str(player) + "Inventory")["weapon"]
		var equipped_weapon_details = inventory.equipped(player, "weapon")

		if player_inventory_weapon_map.has(equipped_weapon_details.name):
			projAmount = player_inventory_weapon_map[equipped_weapon_details.name]
		
		weaponAmountLabel.text = "x " + str(projAmount) # .text assignment (compatible)
	else:
		weaponAmountLabel.text = ""
		
	# Placeholder for armor icon update (assuming similar logic to weaponIcon)
	# For now, setting it to blank or based on inventory.equipped(player, "armor")
	var equipped_armor_data = inventory.equipped(player, "armor")
	if equipped_armor_data and equipped_armor_data.name != "empty" and equipped_armor_data.has("icon"):
		armorIcon.texture = equipped_armor_data.icon # Assuming armor data in inventory has an 'icon' field
	else:
		armorIcon.texture = blankIcon
