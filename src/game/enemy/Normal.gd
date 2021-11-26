extends "res://src/game/enemy/Enemy.gd"
	
const MAX_HP = 100

func _ready():
	max_hp = MAX_HP
	hp = max_hp + (15 * (GameManager.level-1))
	moveSpeed = moveSpeed + (10 * GameManager.level)
	attack = attack + (2 * GameManager.level)
	update_hp_bar()
