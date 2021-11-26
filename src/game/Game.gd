extends Node2D

var scoreFilePath = "user://scores.cfg"

var randomNumberGenerator = RandomNumberGenerator.new()

onready var HPBar = $Wall/GUI/VBoxContainer/HPBar
onready var Score = $Wall/GUI/VBoxContainer/Info/Score
onready var PausePopup = $PausePopup
onready var GameCamera = $GameCamera

onready var player = $"Player"
onready var score = 0

var sectionSize = 8
onready var viewportSize = get_viewport_rect().size
onready var sectionWidth = float(viewportSize[0] / sectionSize)
onready var sectionTrim = sectionWidth / 6

#Sound Effects
onready var coinSoundEffect = AudioStreamPlayer.new()
onready var startGameSoundEffect = AudioStreamPlayer.new()
onready var hurtGameSoundEffect = AudioStreamPlayer.new()

onready var enemies = [
	preload("res://src/game/enemy/Normal.tscn"),
	preload("res://src/game/enemy/Power.tscn"),
	preload("res://src/game/enemy/laser/Laser.tscn")
]

onready var powerups = [
	preload("res://src/game/powerups/HPUp.tscn"),
	preload("res://src/game/powerups/SuperShot.tscn"),
	preload("res://src/game/powerups/PowerUp.tscn")
]

var enemyCoolDown = 0
var enemyCount = 0
var waveCount = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	HPBar.maxHPValue = player.maxHealth
	HPBar.setHealth(player.hp)
	self.add_child(coinSoundEffect)
	coinSoundEffect.stream = load("res://assets/SoundEffect/coin1.wav")
	self.add_child(startGameSoundEffect)
	startGameSoundEffect.stream = load("res://assets/SoundEffect/startGame.wav")
	
	startGameSoundEffect.play()

func _process(delta):
	if GameManager.level < 5:
		GameManager.level = (
			1 if waveCount < 5
			else 2 if waveCount < 10
			else 3 if waveCount < 20
			else 4 if waveCount < 35
			else 5
		)
	else:
		if (waveCount > (GameManager.level+2)*(GameManager.level+3)): #Formula to determine the level
			GameManager.level += 1
			
	enemyCoolDown -= delta
	if enemyCoolDown < 0:
		enemyCoolDown = (
			5 if GameManager.level <= 2
			else 4 if GameManager.level <= 4
			else 3 if GameManager.level <= 9
			else 2 if GameManager.level <= 19
			else 1
		)
		generateEnemy()
		generatePowerups()
	
	if !weakref(player).get_ref():
		HPBar.setHealth(0)
	elif player.hp != HPBar.value:
		HPBar.setHealth(player.hp)
		

func generateEnemy():
	randomNumberGenerator.randomize()

	var sectionIndexes = []
	var numOfEnemies = (
		randomNumberGenerator.randi_range(1, 2) if GameManager.level <= 2
		else randomNumberGenerator.randi_range(2, 3) if GameManager.level <= 4
		else randomNumberGenerator.randi_range(3, 4) if GameManager.level <= 5
		else randomNumberGenerator.randi_range(4, 5) if GameManager.level <= 6
		else randomNumberGenerator.randi_range(5, 6) if GameManager.level <= 7
		else randomNumberGenerator.randi_range(6, 7) if GameManager.level <= 8
		else randomNumberGenerator.randi_range(7, 8)
	)
	
	while sectionIndexes.size() < numOfEnemies:
		var pos = round(randomNumberGenerator.randi_range(0, sectionSize - 1))
		if !sectionIndexes.has(pos):
			sectionIndexes.append(pos)
	
	for pos in sectionIndexes:
		
		var index = (
			0 if GameManager.level <= 1
			else randomNumberGenerator.randi_range(0, 1) if GameManager.level <= 3
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
		randomNumberGenerator.randi_range(0, 1) if GameManager.level <= 2
		else randomNumberGenerator.randi_range(1, 1) if GameManager.level <= 4
		else randomNumberGenerator.randi_range(1, 3)
	)
	
	while sectionIndexes.size() < numOfPowerUps:
		var pos = round(randomNumberGenerator.randi_range(0, sectionSize - 1))
		if !sectionIndexes.has(pos):
			sectionIndexes.append(pos)
	
	for pos in sectionIndexes:
		
		var index = (
			randomNumberGenerator.randi_range(0, 2) if GameManager.level <= 1
			else randomNumberGenerator.randi_range(0, 3) if GameManager.level <= 3
			else randomNumberGenerator.randi_range(0, 4) if GameManager.level <= 8
			else randomNumberGenerator.randi_range(0, 6)
		)
		if index <= 2:
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
	coinSoundEffect.volume_db = -20
	coinSoundEffect.play()
	score += value
	Score.text = String(score)
	
func pause():
	PausePopup.pause()

func gameOver():
	GameManager.level = 1 
	GameManager.numPowerUps = 0
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

func shake():
	
	GameCamera.start()
