extends Node2D

const GENERATE_BOSS_SCORE = 5000

var scoreFilePath = "user://scores.cfg"

var randomNumberGenerator = RandomNumberGenerator.new()

onready var Score = $Wall/GUI/VBoxContainer/Container/Info/Score
onready var Level = $Wall/GUI/VBoxContainer/Container/Info/Level
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
onready var bossGameSoundEffect = AudioStreamPlayer.new()
onready var bossBackgroundMusic = AudioStreamPlayer.new()

onready var enemies = [
	preload("res://src/game/enemy/Normal.tscn"),
	preload("res://src/game/enemy/Power.tscn"),
	preload("res://src/game/enemy/laser/Laser.tscn"),
	preload("res://src/game/enemy/Asteroid.tscn")
]

onready var powerups = [
	preload("res://src/game/powerups/HPUp.tscn"),
	preload("res://src/game/powerups/SuperShot.tscn"),
	preload("res://src/game/powerups/PowerUp.tscn")
]

onready var bosses = [
	preload("res://src/game/boss/boss1/Boss1.tscn")
]
onready var boss_count = 0

var enemyCoolDown = 0
var enemyCount = 0
var waveCount = 0

var is_in_boss = false
var has_boss = false

# Called when the node enters the scene tree for the first time.
func _ready():
	Level.text = String(GameManager.level)
	self.add_child(coinSoundEffect)
	coinSoundEffect.stream = load("res://assets/SoundEffect/coin1.wav")
	self.add_child(startGameSoundEffect)
	startGameSoundEffect.stream = load("res://assets/Soundtracks/draft-monk-ambience.mp3")
	self.add_child(bossGameSoundEffect)
	bossGameSoundEffect.stream = load("res://assets/SoundEffect/warning.wav")
	self.add_child(bossBackgroundMusic)
	bossBackgroundMusic.stream = load("res://assets/Soundtracks/dova_The Evil Sacrifice Archenemies_master.mp3")
	
	startGameSoundEffect.play()

func _process(delta):
	var new_level = GameManager.level
	if new_level < 5:
		new_level = (
			1 if waveCount < 5
			else 2 if waveCount < 10
			else 3 if waveCount < 20
			else 4 if waveCount < 35
			else 5
		)
	else:
		if (waveCount > (new_level + 2)*(new_level + 3)): #Formula to determine the level
			new_level += 1
			
	if GameManager.level != new_level:
		GameManager.level = new_level
		Level.text = String(GameManager.level)
		if GameManager.level > 4:
			is_in_boss = true
	
	enemyCoolDown -= delta
		
	if enemyCoolDown < 0:
		enemyCoolDown = (
			5 if GameManager.level <= 2
			else 4 if GameManager.level <= 4
			else 3 if GameManager.level <= 9
			else 2 if GameManager.level <= 19
			else 1
		)
		
		if is_in_boss:
			if !has_boss:
				generateBoss()
				enemyCoolDown = 0
		else:
			generateEnemy()
			
			
		generatePowerups()

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
			else randomNumberGenerator.randi_range(0, 2) if GameManager.level <= 9
			else randomNumberGenerator.randi_range(0, 3)
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
		randomNumberGenerator.randi_range(1, 1) if GameManager.level <= 1
		else randomNumberGenerator.randi_range(0, 1) if GameManager.level <= 2
		else randomNumberGenerator.randi_range(1, 1) if GameManager.level <= 4
		else randomNumberGenerator.randi_range(1, 3)
	)
	
	while sectionIndexes.size() < numOfPowerUps:
		var pos = round(randomNumberGenerator.randi_range(0, sectionSize - 1))
		if !sectionIndexes.has(pos):
			sectionIndexes.append(pos)
	
	for pos in sectionIndexes:
		
		var index = (
			randomNumberGenerator.randi_range(2, 2) if GameManager.level <= 1
			else randomNumberGenerator.randi_range(0, 2) if GameManager.level <= 2
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

func generateBoss():
	bossGameSoundEffect.volume_db = -5
	bossBackgroundMusic.volume_db = -5
	bossGameSoundEffect.play()
	bossBackgroundMusic.play()
	startGameSoundEffect.stop()
	has_boss = true
	var boss = bosses[0].instance()
	add_child(boss)
	boss_count += 1
	
func killed_boss():
	startGameSoundEffect.play()
	bossBackgroundMusic.stop()
	is_in_boss = false
	has_boss = false
	enemyCoolDown = 0
	

func increaseScore(value):
	coinSoundEffect.volume_db = -20
	coinSoundEffect.play()
	score += value
	Score.text = String(score)
		
func hurtPlayer(ignore_barrier = false):
	player.hurt(GameManager.level, ignore_barrier)
	
func pause():
	PausePopup.pause()

func gameOver():
	# Reset Game data
	GameManager.hp = GameManager.max_hp
	GameManager.energy = 0
	GameManager.level = 1 
	GameManager.numPowerUps = 0
	GameManager.multiShotBonus = 2
	
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
