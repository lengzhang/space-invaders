extends Node2D

var randomNumberGenerator = RandomNumberGenerator.new()

onready var HPBar = $Wall/GUI/VBoxContainer/HPBar
onready var Score = $Wall/GUI/VBoxContainer/Info/Score
onready var PausePopup = $PausePopup

onready var player = $"Player"

onready var level = 1
onready var score = 0

var sectionSize = 8
onready var displayWidth = get_viewport_rect().size[0]
onready var sectionWidth = float(displayWidth / sectionSize)
onready var sectionTrim = sectionWidth / 6

onready var enemies = [
	preload("res://src/game/enemy/Normal.tscn"),
	preload("res://src/game/enemy/Power.tscn")
]

var enemyCoolDown = 0
var enemyCount = 0
var waveCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	HPBar.maxHPValue = player.maxHealth
	HPBar.setHealth(player.hp)

func _process(delta):
	level = (
		1 if waveCount < 5
		else 2 if waveCount < 10
		else 3 if waveCount < 20
		else 4 if waveCount < 35
		else 5
	)
	
	enemyCoolDown -= delta
	if enemyCoolDown < 0:
		enemyCoolDown = (
			5 if level <= 2
			else 4 if level <= 4
			else 3 
		)
		generateEnemy()
	
	if player.hp != HPBar.value:
		HPBar.setHealth(player.hp)
		

func generateEnemy():
	randomNumberGenerator.randomize()
	
	var sectionIndexes = []
	var numOfEnemies = (
		randomNumberGenerator.randi_range(1, 2) if level <= 2
		else randomNumberGenerator.randi_range(2, 3) if level <= 4
		else randomNumberGenerator.randi_range(3, 4)
	)
	
	while sectionIndexes.size() < numOfEnemies:
		var pos = round(randomNumberGenerator.randi_range(0, sectionSize - 1))
		if !sectionIndexes.has(pos):
			sectionIndexes.append(pos)
	
	for pos in sectionIndexes:
		
		var enemy = enemies[0].instance()
		
		var index = (
			0 if level <= 1
			else randomNumberGenerator.randi_range(0, 1) if level <= 3
			else randomNumberGenerator.randi_range(0, 1)
		)
		enemy = enemies[index].instance()
			
		
		var xOffset = randomNumberGenerator.randf_range((
			sectionWidth / 2 if pos == 0
			else sectionTrim
		), (
			sectionWidth - sectionWidth / 2 if pos == sectionSize - 1
			else sectionWidth - sectionTrim
		))
		enemy.position = Vector2(sectionWidth * pos + xOffset, position.y)

		call_deferred("add_child", enemy)
		enemyCount += 1
	waveCount += 1

func increaseScore(value):
	score += value
	Score.text = String(score)
	
func pause():
	PausePopup.pause()

func gameOver():
	get_tree().change_scene("res://src/main_menu/MainMenu.tscn")
