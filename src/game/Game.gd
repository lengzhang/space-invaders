extends Node2D

onready var lifeBar = $"Wall/GUI/Bars/LifeBar"

onready var player = $"Player"

var sectionSize = 8
onready var displayWidth = get_viewport_rect().size[0]
onready var sectionWidth = float(displayWidth / sectionSize)
onready var sectionTrim = sectionWidth / 6

onready var Enemy = preload("res://src/game/enemy/Enemy.tscn")
var enemyCoolDown = 0
var enemyCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	lifeBar.maxValue = player.maxHealth
	lifeBar.setHealth(player.hp)

func _process(delta):
	enemyCoolDown -= delta
	if enemyCoolDown < 0:
		enemyCoolDown = (
			5 if enemyCount < 5
			else 4 if enemyCount < 30
			else 3 
		)
		generateEnemy()
	
	if player.hp != lifeBar.value:
		lifeBar.setHealth(player.hp)
		

func generateEnemy():
	var sectionIndexes = []
	var numOfEnemies = rand_range(1, (
		1 if enemyCount < 5
		else 2 if enemyCount < 10
		else 3
	))
	
	while sectionIndexes.size() < numOfEnemies:
		var pos = round(rand_range(0, sectionSize - 1))
		if !sectionIndexes.has(pos):
			sectionIndexes.append(pos)
	
	for pos in sectionIndexes:	
		var enemy = Enemy.instance()
		var xOffset = rand_range((
			sectionWidth / 2 if pos == 0
			else sectionTrim
		), (
			sectionWidth - sectionWidth / 2 if pos == sectionSize - 1
			else sectionWidth - sectionTrim
		))
		enemy.position = Vector2(sectionWidth * pos + xOffset, position.y)

		call_deferred("add_child", enemy)
		
		enemyCount += 1

func gameOver():
	get_tree().change_scene("res://src/main_menu/MainMenu.tscn")
