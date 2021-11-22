extends KinematicBody2D

var MOVE_SPEED = 300
var attack = 10
var direction: String

func _init(path = "middle"):
	direction = path
	
	#sets attack damage and damage cap
	attack = attack + (3 * GameManager.numPowerUps) #Powerups are permanent.
	if attack > 151:
		attack = 150
	
	add_to_group("player-bullets")

func _physics_process(delta):
	move_and_collide(Vector2.UP * delta * MOVE_SPEED)
	if (direction == "left"):
		move_and_collide(Vector2.LEFT * delta * MOVE_SPEED * 1/6)
	if (direction == "right"):
		move_and_collide(Vector2.RIGHT * delta * MOVE_SPEED * 1/6)

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
		
