extends KinematicBody2D

const MOVE_SPEED = 100

const attack = 10

func _ready():
	add_to_group("enemy-bullets")

func _physics_process(delta):
	move_and_collide(Vector2.DOWN * delta * MOVE_SPEED)
	
func destroy():
	queue_free()

func onExitedBody(body):
#	print(body.name)
#	if (body.name == 'Wall'):
#		destroy()
	pass

func onEnteredArea(area):
	var parent = area.get_parent()
	if parent.name == "Player":
		parent.hurt(attack)

func onExitedArea(area):
	var parentName = area.get_parent().name
	var name = area.name
	if parentName == "Wall" and name == "bottom":
		destroy()
