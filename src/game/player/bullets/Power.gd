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
	print(parent.name)
	if parent.is_in_group("enemies"):
		var enemy = area.get_parent()
		enemy.hurt(attack)
		queue_free()
	elif parent.is_in_group("enemy-bullets"):
		parent.destroy()
		queue_free()
		
