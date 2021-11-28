extends "res://src/game/enemy/Enemy.gd"
	
const MAX_HP = 100

func _ready():
	max_hp = MAX_HP + (15 * (GameManager.level-1))
	hp = max_hp
	moveSpeed = moveSpeed + (10 * GameManager.level)
	attack = attack + (2 * GameManager.level)
	update_hp_bar()
