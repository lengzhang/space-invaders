extends "res://src/game/enemy/Enemy.gd"

var randomNumberGenerator = RandomNumberGenerator.new()

const WAIT_TIME = 0.25
const MOVE_SPEED_X = 100
const MOVE_SPEED_Y = 200
const MAX_HP = 50

# Sound Effects
onready var laserSoundEffect = AudioStreamPlayer.new()

onready var LaserHitBox = $LaserHitBox
onready var LaserCollision = $LaserHitBox/CollisionShape2D

onready var Game = get_node("/root").get_child(0)
onready var viewportWidth = Game.viewportSize[0]
onready var viewportHeight = Game.viewportSize[1]
onready var sectionWidth = Game.sectionWidth
onready var trimWidth = sectionWidth / 2

var stage = 0
var targetPos = [0, 0]
var isToLeft = false
var coolDown = WAIT_TIME

func _ready():
	max_hp = MAX_HP
	hp = max_hp
	update_hp_bar()

	randomNumberGenerator.randomize()
	controlLaser(false)
	self.add_child(laserSoundEffect)
	laserSoundEffect.stream = load("res://assets/SoundEffect/laser4.wav")
	
	# caluclate baseHealth (dependent on level)
	if GameManager.level > 5:
		hp = hp + (18 * (GameManager.level - 1))
	if hp > 150:
		hp = 150
	# calculate target x
	if position.x / viewportWidth <= 0.5:
		# at left half
		targetPos[0] = randomNumberGenerator.randf_range(position.x + sectionWidth, viewportWidth - trimWidth)
		isToLeft = false
	else:
		# at right half
		targetPos[0] = randomNumberGenerator.randf_range(trimWidth, position.x - sectionWidth)
		isToLeft = true
		
	# calculate target y
	targetPos[1] = randomNumberGenerator.randf_range(viewportHeight * 0.15, viewportHeight * 0.35)

func on_physics_process(delta):
	if stage == 0:
		if position.y < targetPos[1]:
			move_and_collide(Vector2.DOWN * delta * MOVE_SPEED_Y)
		else:
			stage += 1
			coolDown = WAIT_TIME
	elif stage == 1:
		coolDown -= delta
		if coolDown < 0:
			controlLaser(true)
			stage += 1
	elif stage == 2:
		if isToLeft:
			if position.x > targetPos[0]:
				move_and_collide(Vector2.LEFT * delta * MOVE_SPEED_X)
			else:
				stage += 1
			coolDown = WAIT_TIME
		else:
			if position.x < targetPos[0]:
				move_and_collide(Vector2.RIGHT * delta * MOVE_SPEED_X)
			else:
				stage += 1
			coolDown = WAIT_TIME
	elif stage == 3:
		coolDown -= delta
		if coolDown < 0:
			controlLaser(false)
			stage += 1
	elif stage == 4:
		move_and_collide(Vector2.DOWN * delta * MOVE_SPEED_Y)
	
func controlLaser(on):
	if on:
		laserSoundEffect.volume_db = -20
		laserSoundEffect.play()
		LaserHitBox.show()
		LaserCollision.disabled = false
	else:
		LaserHitBox.hide()
		LaserCollision.disabled = true
