extends "res://Scenes/Characters/playerCharacters/playerBase.gd"

@onready var meleeAttack = $SpriteContainer/BearedManMelee
@onready var meleeAttackAnimPlayer = $SpriteContainer/BearedManMelee/AnimationPlayer
# _ready() function can be removed if it becomes empty.
# For now, let's keep it if other logic might be added, or remove it if it's truly empty.
# Based on the original, _ready() only contained these assignments. So it can be removed.

func _ready():
	# The assignments are now handled by @onready, so _ready can be empty or used for other init logic.
	# If playerBase._ready() needs to be called and has logic, use super()._ready()
	# For this specific case, if _ready() becomes empty, it can be removed.
	# Let's assume playerBase._ready() might have its own logic that needs to run.
	super._ready() 
	pass

func spawnWeapon(weapon):
	pass
