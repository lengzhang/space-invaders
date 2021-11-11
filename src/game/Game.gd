extends Node2D

onready var lifeBar = $"Wall/GUI/Bars/LifeBar"

onready var player = $"Player"

onready var displayWidth = get_viewport_rect().size[0]

onready var Enemy = preload("res://src/game/enemy/Enemy.tscn")
var enemyCoolDown = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	lifeBar.maxValue = player.maxHealth
	lifeBar.setHealth(player.hp)

func _process(delta):
	enemyCoolDown -= delta
	if enemyCoolDown < 0:
		enemyCoolDown = 2
	
		var enemy = Enemy.instance()
		enemy.position = Vector2(displayWidth/2, position.y)

		call_deferred("add_child", enemy)
	
	if player.hp != lifeBar.value:
		lifeBar.setHealth(player.hp)

func gameOver():
	get_tree().change_scene("res://src/main_menu/MainMenu.tscn")
