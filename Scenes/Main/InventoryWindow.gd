extends Sprite

@onready var tabSelected: Texture = load("res://Images/UI/tabSelected.png")
@onready var tabUnselected: Texture = load("res://Images/UI/tabUnselected.png")
@onready var selector = $Selector

# Added @onready vars for frequently accessed nodes
@onready var items_button = $Tabs/ItemsButton
@onready var weapons_button = $Tabs/WeaponsButton
@onready var armor_button = $Tabs/ArmorButton
@onready var v_slider = $GridBG/VSlider 
@onready var amount_number_label = $GridBG/AmountNumber
@onready var grid_container = $GridBG/GridContainer


var curTab: String
var itemsTabAmount: int
var weaponsTabAmount: int
var armorTabAmount: int
var itemArray: Array
var weaponArray: Array
var armorArray: Array
var indexPlaces = [Vector2(-357, -151), Vector2(-357, -95), Vector2(-357, -39), Vector2(-357, 17), Vector2(-357, 73), Vector2(-357, 129)]
var actualIndexPlaces: Array = []
var curIndex = 0
var tabChangeAllowed = true
var player: int
var numOfItemsInCurrentTab: int
var firstAndLastWeapon: Array = []
var firstAndLastArmor: Array = [] # Original script had this, keep for consistency
var firstAndLastItem: Array = []  # Original script had this, keep for consistency

func _ready():
	match get_parent().name: # Fragile, but kept
		"UICanvasLayer1":
			player = 1
		"UICanvasLayer2":
			player = 2
		"UICanvasLayer3":
			player = 3
		"UICanvasLayer4":
			player = 4
		_: # Default or error case
			player = 1 
			push_warning("InventoryWindow: Could not determine player from parent name: " + get_parent().name)

	curTab = "weapon"
	weapons_button.texture_normal = tabSelected # Use @onready var
	inventoryWindowOpened()
	
func inventoryWindowOpened():
	firstAndLastWeapon.clear()
	firstAndLastArmor.clear()
	firstAndLastItem.clear()

	var p_inventory_array = inventory.get("p" + str(player) + "InventoryArray")
	if p_inventory_array and p_inventory_array.size() >= 3:
		if !p_inventory_array[0].is_empty():
			firstAndLastWeapon.push_front(p_inventory_array[0].front())
			firstAndLastWeapon.push_back(p_inventory_array[0].back())
		if !p_inventory_array[1].is_empty():
			firstAndLastArmor.push_front(p_inventory_array[1].front())
			firstAndLastArmor.push_back(p_inventory_array[1].back())
		if !p_inventory_array[2].is_empty():
			firstAndLastItem.push_front(p_inventory_array[2].front())
			firstAndLastItem.push_back(p_inventory_array[2].back())
	
	calculateInventoryNumbers()
	setupCurrentView(curTab) # This will also update selector visibility and position
	updateItemAmountText()
	setSliderStart()

func calculateInventoryNumbers():
	var player_inventory = inventory.get("p" + str(player) + "Inventory")
	var player_inventory_array = inventory.get("p" + str(player) + "InventoryArray")

	if player_inventory and player_inventory_array and player_inventory_array.size() >=3:
		itemsTabAmount = player_inventory["items"].size()
		weaponsTabAmount = player_inventory["weapon"].size()
		armorTabAmount = player_inventory["armor"].size()
		weaponArray = player_inventory_array[0].duplicate(true)
		armorArray = player_inventory_array[1].duplicate(true)
		itemArray = player_inventory_array[2].duplicate(true)
	else:
		itemsTabAmount = 0; weaponsTabAmount = 0; armorTabAmount = 0
		weaponArray.clear(); armorArray.clear(); itemArray.clear()

			
func setSliderStart():
	var max_val = 0
	match curTab:
		"item": max_val = itemsTabAmount
		"weapon": max_val = weaponsTabAmount
		"armor": max_val = armorTabAmount
	
	if max_val > 0:
		v_slider.max_value = max_val - 1
		v_slider.value = v_slider.max_value 
	else:
		v_slider.max_value = 0
		v_slider.value = 0
	v_slider.page = float(indexPlaces.size()) # Page should be float
			
func setupCurrentView(type: String):
	var numOfIterations: int
	var inventoryArray_local: Array
	match type:
		"item":
			numOfItemsInCurrentTab = itemsTabAmount
			numOfIterations = itemsTabAmount
			inventoryArray_local = itemArray
		"weapon":
			numOfItemsInCurrentTab = weaponsTabAmount
			numOfIterations = weaponsTabAmount
			inventoryArray_local = weaponArray
		"armor":
			numOfItemsInCurrentTab = armorTabAmount
			numOfIterations = armorTabAmount
			inventoryArray_local = armorArray
		_:
			numOfItemsInCurrentTab = 0; numOfIterations = 0; inventoryArray_local = []
			
	# Corrected slice for Godot 4: slice(begin, end_exclusive)
	# To get N elements starting from 0, it's slice(0, N)
	actualIndexPlaces = indexPlaces.slice(0, min(numOfIterations, indexPlaces.size())) 
				
	v_slider.max_value = float(max(0, numOfItemsInCurrentTab - 1))
	v_slider.visible = numOfItemsInCurrentTab > indexPlaces.size()
		
	for i in range(indexPlaces.size()): # Iterate through display slots
		var texture_rect_node = grid_container.get_node_or_null("TextureRect" + str(i + 1)) as TextureRect
		var label_node = grid_container.get_node_or_null("Label" + str(i + 1)) as Label

		if texture_rect_node and label_node:
			# Original logic for scrolling was in moveSelector by modifying array.
			# This setupCurrentView shows items from the start of inventoryArray_local.
			# For proper VSlider integration, inventoryArray_local should be sliced based on v_slider.value
			var item_index_to_display = i + int(v_slider.value) # Assuming v_slider.value is the top visible item index

			if item_index_to_display < inventoryArray_local.size() and item_index_to_display < numOfIterations:
				var item_name = inventoryArray_local[item_index_to_display]
				if inventory.database[type].has(item_name) and inventory.database[type][item_name].has("icon"):
					texture_rect_node.texture = inventory.database[type][item_name].icon
					label_node.text = item_name # Or use a display name from database
					texture_rect_node.visible = true
					label_node.visible = true
				else: # Item name not in database or no icon
					texture_rect_node.visible = false; label_node.visible = false
					texture_rect_node.texture = null; label_node.text = ""
			else: # No item for this slot
				texture_rect_node.visible = false
				label_node.visible = false
				texture_rect_node.texture = null
				label_node.text = ""
	
	selector.visible = (numOfItemsInCurrentTab > 0 and !actualIndexPlaces.is_empty())
	if selector.visible:
		curIndex = clamp(curIndex, 0, actualIndexPlaces.size() - 1) # Ensure curIndex is valid for visible slots
		selector.position = actualIndexPlaces[curIndex]
	else:
		curIndex = 0 # Reset if not visible

	updateItemAmountText() # Update text based on current selection

async func moveSelector(direction: String):
	if not tabChangeAllowed: return

	tabChangeAllowed = false
	var view_size = actualIndexPlaces.size() # Number of actual visible slots based on items

	if view_size > 0: # Only move if there are items to select from
		var old_slider_value = v_slider.value
		match direction:
			"up":
				if curIndex > 0:
					curIndex -= 1
				elif v_slider.value > 0: # If at the top of visible list, try to scroll up
					v_slider.value -= 1
					# No need to change curIndex, setupCurrentView will refresh items
			"down":
				if curIndex < view_size - 1:
					curIndex += 1
				elif v_slider.value < v_slider.max_value: # If at bottom, try to scroll down
					v_slider.value += 1
			"left":
				await changeTab("left")
			"right":
				await changeTab("right")
		
		if old_slider_value != v_slider.value: # If slider value changed, refresh view
			setupCurrentView(curTab) 
			# curIndex might need adjustment if the number of actualIndexPlaces changes
			curIndex = clamp(curIndex, 0, max(0, actualIndexPlaces.size() -1 ))


		if direction == "up" or direction == "down": # Only update for up/down if not a tab change
			if curIndex < actualIndexPlaces.size(): # Ensure curIndex is valid for potentially changed actualIndexPlaces
				selector.position = actualIndexPlaces[curIndex]
			updateItemAmountText()

	await get_tree().create_timer(0.2).timeout # Original cooldown
	tabChangeAllowed = true
			
async func changeTab(direction: String):
	var original_tab = curTab
	match curTab:
		"item": curTab = "armor" if direction == "left" else "weapon"
		"weapon": curTab = "item" if direction == "left" else "armor"
		"armor": curTab = "weapon" if direction == "left" else "item"

	if original_tab != curTab:
		items_button.texture_normal = tabUnselected
		weapons_button.texture_normal = tabUnselected
		armor_button.texture_normal = tabUnselected
		match curTab:
			"item": items_button.texture_normal = tabSelected
			"weapon": weapons_button.texture_normal = tabSelected
			"armor": armor_button.texture_normal = tabSelected
		
		curIndex = 0 # Reset index for new tab
		# inventoryWindowOpened() will call calculate, setupCurrentView, updateItemAmountText, setSliderStart
		inventoryWindowOpened() 

	await get_tree().create_timer(0.2).timeout # Shortened from original 1s, matches moveSelector cooldown
	
func itemSelected():
	var current_inventory_array: Array
	match curTab:
		"item": current_inventory_array = itemArray
		"weapon": current_inventory_array = weaponArray
		"armor": current_inventory_array = armorArray
		_: return null

	# curIndex is relative to the visible slots. Slider value indicates the top item of the view.
	var actual_item_index = curIndex + int(v_slider.value)

	if not current_inventory_array.is_empty() and \
	   actual_item_index >= 0 and actual_item_index < current_inventory_array.size():
		return current_inventory_array[actual_item_index]
	return null
				
func updateItemAmountText():
	var item_name = itemSelected() # This now gets item based on curIndex + slider value
	var amount = 0
	if item_name:
		var player_inv_for_tab_type: Dictionary
		var tab_key = curTab
		if tab_key == "item": tab_key = "items" # Adjust for dict key "items"

		var player_inventory = inventory.get("p" + str(player) + "Inventory")
		if player_inventory and player_inventory.has(tab_key):
			player_inv_for_tab_type = player_inventory[tab_key]
			if player_inv_for_tab_type.has(item_name):
				amount = player_inv_for_tab_type[item_name]
			
	amount_number_label.text = str(amount) if item_name else "0"


func _on_ItemsButton_pressed():
	if curTab == "item": return
	curTab = "item"
	items_button.texture_normal = tabSelected
	weapons_button.texture_normal = tabUnselected
	armor_button.texture_normal = tabUnselected
	curIndex = 0
	inventoryWindowOpened()

func _on_WeaponsButton_pressed():
	if curTab == "weapon": return
	curTab = "weapon"
	items_button.texture_normal = tabUnselected
	weapons_button.texture_normal = tabSelected
	armor_button.texture_normal = tabUnselected
	curIndex = 0
	inventoryWindowOpened()

func _on_ArmorButton_pressed():
	if curTab == "armor": return
	curTab = "armor"
	items_button.texture_normal = tabUnselected
	armor_button.texture_normal = tabSelected
	weapons_button.texture_normal = tabUnselected
	curIndex = 0
	inventoryWindowOpened()

func useSelected():
	var item_name = itemSelected()
	if item_name:
		print("Player ", player, " attempts to use/select: ", item_name, " from tab: ", curTab)
		# Actual game logic for using, equipping, or dropping items would go here.
		# Example:
		# match curTab:
		#     "item": inventory.useItem(player, item_name)
		#     "weapon": inventory.equipWeapon(player, item_name) # Or unequip if already equipped
		#     "armor": inventory.equipArmor(player, item_name)   # Or unequip
		# After action, refresh inventory state and view:
		inventoryWindowOpened()

func _on_VSlider_value_changed(value: float):
	# When slider changes, rebuild the current view with new offset
	# curIndex should ideally remain relative to the view or be reset.
	# For simplicity, let's try to keep curIndex if possible, clamped to new view size.
	var old_selected_item = itemSelected() # Get item before view changes

	setupCurrentView(curTab) # This now uses v_slider.value to display correct items

	# Try to restore selection or select the top item if old selection is out of view
	if old_selected_item:
		var current_view_items = []
		var full_array : Array
		match curTab:
			"item": full_array = itemArray
			"weapon": full_array = weaponArray
			"armor": full_array = armorArray
		
		var start_index = int(v_slider.value)
		var end_index = start_index + actualIndexPlaces.size()
		if start_index < full_array.size(): # Ensure start_index is valid
			current_view_items = full_array.slice(start_index, min(end_index, full_array.size()))

		var new_cur_index = current_view_items.find(old_selected_item)
		if new_cur_index != -1:
			curIndex = new_cur_index
		else:
			curIndex = 0 # Default to top of the new view
	else:
		curIndex = 0
	
	curIndex = clamp(curIndex, 0, max(0, actualIndexPlaces.size() - 1))
	if !actualIndexPlaces.is_empty() and selector.visible:
		selector.position = actualIndexPlaces[curIndex]

	updateItemAmountText()
	# updateItemDetails() # If exists
	# updateButtonStates() # If exists
