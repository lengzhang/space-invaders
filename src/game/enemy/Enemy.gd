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
