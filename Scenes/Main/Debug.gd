extends Label

func _ready():
	inventory.addItem(1, "weapon", "stone", 2)
	inventory.addItem(1, "weapon", "dart", 100)
	inventory.addItem(1, "weapon", "wooden stick", 1)
	inventory.addItem(1, "weapon", "boomerang", 1)
	inventory.addItem(1, "weapon", "smoke bomb", 5)
	inventory.addItem(1, "weapon", "wood battle hammer", 1)
	inventory.addItem(1, "weapon", "wood sword", 1)
	inventory.p1Equipped["weapon"] = "stone"
	inventory.addItem(2, "weapon", "stone", 50)
	inventory.addItem(2, "weapon", "dart", 100)
	inventory.addItem(2, "weapon", "wooden stick", 1)
	inventory.addItem(2, "weapon", "boomerang", 1)
	inventory.addItem(2, "weapon", "smoke bomb", 5)
	inventory.addItem(2, "weapon", "wood battle hammer", 1)
	inventory.addItem(2, "weapon", "wood sword", 1)
	inventory.p2Equipped["weapon"] = "dart"
	inventory.addItem(3, "weapon", "dart", 100)
	inventory.addItem(3, "weapon", "stone", 50)
	inventory.addItem(3, "weapon", "wooden stick", 1)
	inventory.p3Equipped["weapon"] = "wooden stick"
	inventory.addItem(4, "weapon", "dart", 100)
	inventory.addItem(4, "weapon", "stone", 50)
	inventory.addItem(4, "weapon", "wooden stick", 1)
	inventory.p4Equipped["weapon"] = "stone"

func _process(delta):
	#print(inventory.p1Inventory["weapon"])
	pass
