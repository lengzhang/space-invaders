extends "res://src/classic_game/enemy/Enemy.gd"

const FIRE_COOL_DOWN = 1.5
const FIRE_RATE = 10

onready var BULLET = preload("res://src/classic_game/enemy/Bullet.tscn")

onready var randomNumberGenerator

onready var fireCoolDown = 0

func _ready():
	randomNumberGenerator = RandomNumberGenerator.new()
	randomNumberGenerator.seed = hash(get_instance_id())
	type = 2

func _physics_process(delta):
	if fireCoolDown >= FIRE_COOL_DOWN:
		var rate = randomNumberGenerator.randi_range(1, 100)
		if rate >= 100 - min((FIRE_RATE * Wave.level), 50):
			fire()
		fireCoolDown = 0
	else:
		fireCoolDown += delta

func fire():
	var bullet = BULLET.instance()
	bullet.position = Vector2(position.x, position.y + 32)
	get_parent().call_deferred("add_child", bullet)
