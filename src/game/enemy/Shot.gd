extends KinematicBody2D

const MOVE_SPEED = 50
const attack = 10


var hp = 100

var isInGame = false
	
func _ready():
	add_to_group("enemies")
	isInGame = false



func _physics_process(delta):
	move_and_collide(Vector2.DOWN * delta * MOVE_SPEED)
	
	
func fire():
	var bullet = preload(BULLET_POWER) if shipMode == 0 else preload(BULLET_SHOT)
	var firedBullet = bullet.instance()
	firedBullet.position = Vector2(position.x, position.y - 24)
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
