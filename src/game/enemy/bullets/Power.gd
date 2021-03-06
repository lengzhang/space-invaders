extends KinematicBody2D

var bulletSpeed = 70
const attack = 10

onready var parent = get_parent()

func _ready():
	bulletSpeed = bulletSpeed + (15 * GameManager.level)
	add_to_group("enemy-bullets")

func _physics_process(delta):
	move_and_collide(Vector2.DOWN * delta * bulletSpeed)

func hurt():
	if parent.has_method("increaseScore"):
		parent.increaseScore(1)
	destroy()
	
func destroy():
	queue_free()

func onExitedBody(body):
	if (body.name == 'Wall'):
		destroy()

func onEnteredArea(area):
	var parent = area.get_parent()
	if parent.name == "Player":
		parent.hurt(attack)
		destroy()
