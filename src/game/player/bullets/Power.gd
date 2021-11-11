extends KinematicBody2D

const MOVE_SPEED = 300

const attack = 10

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
		parent.hurt(attack)
		queue_free()
	elif parent.is_in_group("enemy-bullets"):
		parent.hurt()
		queue_free()
		
