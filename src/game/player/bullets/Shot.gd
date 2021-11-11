extends KinematicBody2D

const MOVE_SPEED = 300
const MAX_HIT_COUNT = 3

const attack = 10

var hitCount = MAX_HIT_COUNT

func _ready():
	add_to_group("player-bullets")

func _physics_process(delta):
	move_and_collide(Vector2.UP * delta * MOVE_SPEED)

func onExitedBody(body):
	if (body.name == 'Wall'):
		queue_free()

func onEnteredArea(area):
	var parent = area.get_parent()
	if parent.is_in_group("enemies"):
		var enemy = area.get_parent()
		enemy.hurt(attack)
		hitCount -= 1
	elif parent.is_in_group("enemy-bullets"):
		parent.destroy()
		hitCount -= 1
		
	if hitCount <= 0:
		queue_free()
