extends KinematicBody2D

const MOVE_SPEED = 25
const MAX_HP = 100
const FIRE_COOL_DOWN = 1.5
const attack = 10

const BULLET = "res://src/game/enemy/bullets/Power.tscn"

onready var parent = get_parent()

onready var fireCoolDown = FIRE_COOL_DOWN

var hp = MAX_HP

var isInGame = false
	
func _ready():
	add_to_group("enemies")
	isInGame = false


func _physics_process(delta):
	move_and_collide(Vector2.DOWN * delta * MOVE_SPEED)
	
	# Fire
	fireCoolDown += delta	
	if fireCoolDown >= FIRE_COOL_DOWN:
		fire()
		fireCoolDown = 0

func fire():
	var bullet = preload(BULLET)
	var firedBullet = bullet.instance()
	firedBullet.position = Vector2(position.x, position.y + 25)
	get_parent().call_deferred("add_child", firedBullet)
	
func kill():
	queue_free()

func hurt(damage):
	hp -= damage
	if hp <= 0:
		kill()
		if parent.has_method("increaseScore"):
			parent.increaseScore(MAX_HP)

func onExitedBody(body):
	if body.name == "Wall":
		if isInGame:
			isInGame = false
			kill()
		else:
			isInGame = true
