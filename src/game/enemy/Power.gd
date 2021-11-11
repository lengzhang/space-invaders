extends KinematicBody2D

const MOVE_SPEED = 25
const FIRE_COOL_DOWN = 1.5

const BULLET = "res://src/game/enemy/bullets/Power.tscn"

const attack = 10
onready var fireCoolDown = FIRE_COOL_DOWN

var hp = 100

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

func onExitedBody(body):
	if body.name == "Wall":
		if isInGame:
			isInGame = false
			kill()
		else:
			isInGame = true
