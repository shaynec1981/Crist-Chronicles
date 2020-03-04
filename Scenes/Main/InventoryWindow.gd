extends Sprite

onready var tabSelected = load("res://Images/UI/tabSelected.png")
onready var tabUnselected = load("res://Images/UI/tabUnselected.png")
onready var selector = $Selector

var curTab
var itemsTabAmount
var weaponsTabAmount
var armorTabAmount
var itemArray
var weaponArray
var armorArray
var indexPlaces = [Vector2(-357, -151), Vector2(-357, -95), Vector2(-357, -39), Vector2(-357, 17), Vector2(-357, 73), Vector2(-357, 129)]
var actualIndexPlaces = []
var curIndex = 0
var tabChangeAllowed = true
var player
var numOfItemsInCurrentTab
var firstAndLastWeapon = []
var firstAndLastArmor = []
var firstAndLastItem = []

func _ready():
	match get_parent().name:
		"UICanvasLayer1":
			player = 1
		"UICanvasLayer2":
			player = 2
		"UICanvasLayer3":
			player = 3
		"UICanvasLayer4":
			player = 4
	curTab = "weapon"
	$Tabs/WeaponsButton.texture_normal = tabSelected
	inventoryWindowOpened()
	
func inventoryWindowOpened():
	firstAndLastWeapon.clear()
	match player:
		1:
			firstAndLastWeapon.push_front(inventory.p1InventoryArray[0].back())
			firstAndLastWeapon.push_front(inventory.p1InventoryArray[0].front())
		2:
			firstAndLastWeapon.push_front(inventory.p2InventoryArray[0].back())
			firstAndLastWeapon.push_front(inventory.p2InventoryArray[0].front())
		3:
			firstAndLastWeapon.push_front(inventory.p3InventoryArray[0].back())
			firstAndLastWeapon.push_front(inventory.p3InventoryArray[0].front())
		4:
			firstAndLastWeapon.push_front(inventory.p4InventoryArray[0].back())
			firstAndLastWeapon.push_front(inventory.p4InventoryArray[0].front())
	calculateInventoryNumbers()
	setupCurrentView("weapon")
	updateItemAmountText()
	
func calculateInventoryNumbers():
	match get_node("..").name:
		"UICanvasLayer1":
			itemsTabAmount = inventory.p1Inventory["items"].size()
			weaponsTabAmount = inventory.p1Inventory["weapon"].size()
			armorTabAmount = inventory.p1Inventory["armor"].size()
			weaponArray = inventory.p1InventoryArray[0].duplicate()
			armorArray = inventory.p1InventoryArray[1].duplicate()
			itemArray = inventory.p1InventoryArray[2].duplicate()
		"UICanvasLayer2":
			itemsTabAmount = inventory.p2Inventory["items"].size()
			weaponsTabAmount = inventory.p2Inventory["weapon"].size()
			armorTabAmount = inventory.p2Inventory["armor"].size()
			weaponArray = inventory.p2InventoryArray[0].duplicate()
			armorArray = inventory.p2InventoryArray[1].duplicate()
			itemArray = inventory.p2InventoryArray[2].duplicate()
		"UICanvasLayer3":
			itemsTabAmount = inventory.p3Inventory["items"].size()
			weaponsTabAmount = inventory.p3Inventory["weapon"].size()
			armorTabAmount = inventory.p3Inventory["armor"].size()
			weaponArray = inventory.p3InventoryArray[0].duplicate()
			armorArray = inventory.p3InventoryArray[1].duplicate()
			itemArray = inventory.p3InventoryArray[2].duplicate()
		"UICanvasLayer4":
			itemsTabAmount = inventory.p4Inventory["items"].size()
			weaponsTabAmount = inventory.p4Inventory["weapon"].size()
			armorTabAmount = inventory.p4Inventory["armor"].size()
			weaponArray = inventory.p4InventoryArray[0].duplicate()
			armorArray = inventory.p4InventoryArray[1].duplicate()
			itemArray = inventory.p4InventoryArray[2].duplicate()
			
func setSliderStart():
	match curTab:
		"item":
			if weaponsTabAmount != 0:
				get_node("VSlider").max_value = itemsTabAmount - 1
				get_node("VSlider").value = itemsTabAmount - 1
			else:
				get_node("VSlider").max_value = 0
				get_node("VSlider").value = 0
		"weapon":
			if weaponsTabAmount != 0:
				get_node("VSlider").max_value = weaponsTabAmount - 1
				get_node("VSlider").value = weaponsTabAmount - 1
			else:
				get_node("VSlider").max_value = 0
				get_node("VSlider").value = 0
		"armor":
			if weaponsTabAmount != 0:
				get_node("VSlider").max_value = armorTabAmount - 1
				get_node("VSlider").value = armorTabAmount - 1
			else:
				get_node("VSlider").max_value = 0
				get_node("VSlider").value = 0
			
func setupCurrentView(type):
	var numOfIterations
	var textureVar = "GridContainer/TextureRect"
	var labelVar = "GridContainer/Label"
	var inventoryArray
	match type:
		"item":
			numOfItemsInCurrentTab = itemsTabAmount
			numOfIterations = itemsTabAmount
			inventoryArray = itemArray.duplicate()
			actualIndexPlaces = indexPlaces.slice(0, numOfIterations - 1)
			if itemsTabAmount == 0:
				selector.visible = false
			else:
				selector.visible = true
		"weapon":
			numOfItemsInCurrentTab = weaponsTabAmount
			numOfIterations = weaponsTabAmount
			inventoryArray = weaponArray.duplicate()
			actualIndexPlaces = indexPlaces.duplicate()
			actualIndexPlaces = actualIndexPlaces.slice(0, numOfIterations - 1)
			if weaponsTabAmount == 0:
				selector.visible = false
			else:
				selector.visible = true
		"armor":
			numOfItemsInCurrentTab = armorTabAmount
			numOfIterations = armorTabAmount
			inventoryArray = armorArray.duplicate()
			actualIndexPlaces = indexPlaces.slice(0, numOfIterations - 1)
			if armorTabAmount == 0:
				selector.visible = false
			else:
				selector.visible = true
				
	get_node("VSlider").max_value = numOfItemsInCurrentTab - 1
		
	for i in 6:
		if i + 1 <= numOfIterations:
			get_node(textureVar + str(i + 1)).texture = inventory.database[type][inventoryArray[i]].icon
			get_node(labelVar + str(i + 1)).text = inventoryArray[i]
			get_node(textureVar + str(i + 1)).visible = true
			get_node(labelVar + str(i + 1)).visible = true
		else:
			get_node(textureVar + str(i + 1)).visible = false
			get_node(labelVar + str(i + 1)).visible = false
			
func moveSelector(direction):
	if tabChangeAllowed:
		match direction:
			"up":
				if curIndex == 0:
					var curItem = itemSelected()
					var arrType
					match curTab:
						"weapon":
							arrType = firstAndLastWeapon.duplicate()
						"armor":
							arrType = firstAndLastArmor.duplicate()
						"item":
							arrType = firstAndLastItem.duplicate()
					if curItem != arrType[0]:
						var tempHolder
						var catType
						match curTab:
							"item":
								catType = itemArray
							"weapon":
								catType = weaponArray
							"armor":
								catType = armorArray
						tempHolder = catType.pop_back()
						catType.push_front(tempHolder)
						get_node("VSlider").value += 1
						setupCurrentView(curTab)
					else:
						if actualIndexPlaces.size() - 1 >= 6:
							curIndex = 5
							var tempHolder
							match curTab:
								"item":
									arrType = itemArray
								"weapon":
									arrType = weaponArray
								"armor":
									arrType = armorArray
							tempHolder = arrType.pop_front()
							arrType.push_back(tempHolder)
							get_node("VSlider").value = 0
							setupCurrentView(curTab)
						else:
							curIndex = actualIndexPlaces.size() - 1
							get_node("VSlider").value = 0
				else:
					curIndex -= 1
					get_node("VSlider").value += 1
				selector.position = actualIndexPlaces[curIndex]
				updateItemAmountText()
			"down":
				if curIndex == actualIndexPlaces.size() - 1 || curIndex >= 5:
					if numOfItemsInCurrentTab >= 7 && itemSelected() != firstAndLastWeapon[1]:
						var arrType
						var tempHolder
						match curTab:
							"item":
								arrType = itemArray
							"weapon":
								arrType = weaponArray
							"armor":
								arrType = armorArray
						tempHolder = arrType.pop_front()
						arrType.push_back(tempHolder)
						get_node("VSlider").value -= 1
						setupCurrentView(curTab)
					else:
						var playerInventoryArray
						var typeNum
						var arrType
						match curTab:
							"item":
								typeNum = 2
								arrType = itemArray
							"weapon":
								typeNum = 0
								arrType = weaponArray
							"armor":
								typeNum = 1
								arrType = armorArray
						curIndex = 0
						get_node("VSlider").value = get_node("VSlider").max_value
						match player:
							1:
								weaponArray = inventory.p1InventoryArray[0].duplicate()
								armorArray = inventory.p1InventoryArray[1].duplicate()
								itemArray = inventory.p1InventoryArray[2].duplicate()
							2:
								weaponArray = inventory.p2InventoryArray[0].duplicate()
								armorArray = inventory.p2InventoryArray[1].duplicate()
								itemArray = inventory.p2InventoryArray[2].duplicate()
							3:
								weaponArray = inventory.p3InventoryArray[0].duplicate()
								armorArray = inventory.p3InventoryArray[1].duplicate()
								itemArray = inventory.p3InventoryArray[2].duplicate()
							4:
								weaponArray = inventory.p4InventoryArray[0].duplicate()
								armorArray = inventory.p4InventoryArray[1].duplicate()
								itemArray = inventory.p4InventoryArray[2].duplicate()
						setupCurrentView(curTab)
				else:
					curIndex += 1
					get_node("VSlider").value -= 1
				selector.position = actualIndexPlaces[curIndex]
				updateItemAmountText()
			"left":
				changeTab("left")
			"right":
				changeTab("right")
		tabChangeAllowed = false
		yield(get_tree().create_timer(0.2), "timeout")
		tabChangeAllowed = true
			
func changeTab(direction):
	match curTab:
		"item":
			if direction == "right":
				numOfItemsInCurrentTab = weaponsTabAmount
				_on_WeaponsButton_pressed()
			else:
				numOfItemsInCurrentTab = armorTabAmount
				_on_ArmorButton_pressed()
		"weapon":
			if direction == "right":
				numOfItemsInCurrentTab = armorTabAmount
				_on_ArmorButton_pressed()
			else:
				numOfItemsInCurrentTab = itemsTabAmount
				_on_ItemsButton_pressed()
		"armor":
			if direction == "right":
				numOfItemsInCurrentTab = itemsTabAmount
				_on_ItemsButton_pressed()
			else:
				numOfItemsInCurrentTab = weaponsTabAmount
				_on_WeaponsButton_pressed()
	yield(get_tree().create_timer(1), "timeout")
	
func itemSelected():
	match curTab:
		"item":
			if itemArray.size() > 0:
				return itemArray[curIndex]
		"weapon":
			if weaponArray.size() > 0:
				return weaponArray[curIndex]
		"armor":
			if armorArray.size() > 0:
				return armorArray[curIndex]
				
func updateItemAmountText():
	var item = itemSelected()
	match curTab:
		"item":
			if itemArray.size() > 0:
				$GridBG/AmountNumber.text = str(inventory.numOfItems(player, itemArray[curIndex]))
			else:
				$GridBG/AmountNumber.text = "0"
		"weapon":
			if weaponArray.size() > 0:
				$GridBG/AmountNumber.text = str(inventory.numOfWeapons(player, weaponArray[curIndex]))
			else:
				$GridBG/AmountNumber.text = "0"
		"armor":
			if armorArray.size() > 0:
				$GridBG/AmountNumber.text = str(inventory.numOfArmor(player, armorArray[curIndex]))
			else:
				$GridBG/AmountNumber.text = "0"

func _on_ItemsButton_pressed():
	curTab = "item"
	curIndex = 0
	selector.position = actualIndexPlaces[curIndex]
	$Tabs/ItemsButton.texture_normal = tabSelected
	$Tabs/WeaponsButton.texture_normal = tabUnselected
	$Tabs/ArmorButton.texture_normal = tabUnselected
	setSliderStart()
	setupCurrentView("item")
	updateItemAmountText()

func _on_WeaponsButton_pressed():
	curTab = "weapon"
	curIndex = 0
	selector.position = actualIndexPlaces[curIndex]
	$Tabs/ItemsButton.texture_normal = tabUnselected
	$Tabs/WeaponsButton.texture_normal = tabSelected
	$Tabs/ArmorButton.texture_normal = tabUnselected
	setSliderStart()
	setupCurrentView("weapon")
	updateItemAmountText()

func _on_ArmorButton_pressed():
	curTab = "armor"
	curIndex = 0
	selector.position = actualIndexPlaces[curIndex]
	$Tabs/ItemsButton.texture_normal = tabUnselected
	$Tabs/ArmorButton.texture_normal = tabSelected
	$Tabs/WeaponsButton.texture_normal = tabUnselected
	setSliderStart()
	setupCurrentView("armor")
	updateItemAmountText()

func useSelected():
	print(itemSelected())
