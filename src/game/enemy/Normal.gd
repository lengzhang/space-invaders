extends KinematicBody2D


const MOVE_SPEED = 25
const MAX_HP = 100
const attack = 10

onready var parent = get_parent()

var hp = MAX_HP

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
		if parent.has_method("increaseScore"):
			parent.increaseScore(MAX_HP)

func onExitedBody(body):
	if body.name == "Wall":
		if isInGame:
			isInGame = false
			kill()
		else:
			isInGame = true
