extends "res://src/game/enemy/Enemy.gd"

const MAX_HP = 100
const FIRE_COOL_DOWN = 1.5

# Sound Effect
onready var shootShoundEffect = AudioStreamPlayer.new()

onready var Bullet = preload("res://src/game/enemy/bullets/Power.tscn")

onready var fireCoolDown = FIRE_COOL_DOWN

func _ready():
	max_hp = MAX_HP + (15 * (GameManager.level-1))
	hp = max_hp
	moveSpeed = moveSpeed + (10 * GameManager.level)
	attack = attack + (2 * GameManager.level)
	update_hp_bar()

func _physics_process(delta):
	# Fire
	fireCoolDown += delta	
	if fireCoolDown >= FIRE_COOL_DOWN:
		fire()
		fireCoolDown = 0

func fire():
	var firedBullet = Bullet.instance()
	firedBullet.position = Vector2(position.x, position.y + 25)
	get_parent().call_deferred("add_child", firedBullet)
