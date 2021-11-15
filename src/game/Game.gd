extends Node2D

var scoreFilePath = "user://scores.cfg"

var randomNumberGenerator = RandomNumberGenerator.new()

onready var HPBar = $Wall/GUI/VBoxContainer/HPBar
onready var Score = $Wall/GUI/VBoxContainer/Info/Score
onready var PausePopup = $PausePopup

onready var player = $"Player"

onready var level = 1
onready var score = 0

var sectionSize = 8
onready var viewportSize = get_viewport_rect().size
onready var sectionWidth = float(viewportSize[0] / sectionSize)
onready var sectionTrim = sectionWidth / 6

onready var enemies = [
	preload("res://src/game/enemy/Normal.tscn"),
	preload("res://src/game/enemy/Power.tscn"),
	preload("res://src/game/enemy/laser/Laser.tscn")
]

onready var powerups = [
	preload("res://src/game/powerups/HPUp.tscn"),
	preload("res://src/game/powerups/SuperShot.tscn")
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
		generatePowerups()
	
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
		
		var index = (
			0 if level <= 1
			else randomNumberGenerator.randi_range(0, 1) if level <= 3
			else randomNumberGenerator.randi_range(0, 2)
		)
		var enemy = enemies[index].instance()
			
		
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

func generatePowerups():
	randomNumberGenerator.randomize()
	
	var sectionIndexes = []
	var numOfPowerUps = (
		randomNumberGenerator.randi_range(0, 1) if level <= 2
		else randomNumberGenerator.randi_range(1, 1) if level <= 4
		else randomNumberGenerator.randi_range(1, 3)
	)
	
	while sectionIndexes.size() < numOfPowerUps:
		var pos = round(randomNumberGenerator.randi_range(0, sectionSize - 1))
		if !sectionIndexes.has(pos):
			sectionIndexes.append(pos)
	
	for pos in sectionIndexes:
		
		var index = (
			randomNumberGenerator.randi_range(0, 1) if level <= 1
			else randomNumberGenerator.randi_range(0, 2) if level <= 3
			else randomNumberGenerator.randi_range(0, 3)
		)
		if index <= 1:
			var powerUp = powerups[index].instance()
				
			var xOffset = randomNumberGenerator.randf_range((
				sectionWidth / 2 if pos == 0
				else sectionTrim
			), (
				sectionWidth - sectionWidth / 2 if pos == sectionSize - 1
				else sectionWidth - sectionTrim
			))
			powerUp.position = Vector2(sectionWidth * pos + xOffset, position.y)

			call_deferred("add_child", powerUp)

func increaseScore(value):
	score += value
	Score.text = String(score)
	
func pause():
	PausePopup.pause()

func gameOver():
	var config = ConfigFile.new()
	
	var err = config.load(scoreFilePath)
	if err != OK:
		config = ConfigFile.new()
	
	var time = OS.get_datetime()

	var timeStr = (
		String(time.get("year"))
		+ "-" + String(time.get("month"))
		+ "-" + String(time.get("day"))
		+ " " + String(time.get("hour"))
		+ ":" + String(time.get("minute"))
		+ ":" + String(time.get("second"))
	)
	
	config.set_value("scores", timeStr, String(score))
	
	config.save(scoreFilePath)
	
	get_tree().change_scene("res://src/main_menu/MainMenu.tscn")

















