extends Node2D

const BULLET_SPEED = 50
const BULLET_COUNT = 6
const DEFAULT_RADIUS = 0.5

onready var Bullet = preload("res://src/game/boss/bullet/bullet2/SubBullet.tscn")

onready var viewport_size = get_viewport_rect().size

onready var bullet_speed = BULLET_SPEED + (15 * GameManager.level)
onready var bullet_count = BULLET_COUNT + (2 * GameManager.level)

func _ready():
	for i in range(0, BULLET_COUNT):
		var bullet = Bullet.instance()
		bullet.set_destoryable(i % 2 == 1)
		var angle = 2 * PI / BULLET_COUNT * i
		bullet.position.x = cos(angle) * DEFAULT_RADIUS
		bullet.position.y = sin(angle) * DEFAULT_RADIUS
		add_child(bullet)

func _physics_process(delta):
	if position.y >= viewport_size.y * 1.5:
		queue_free()
	move_local_y(delta * bullet_speed)
	
