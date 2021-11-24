extends KinematicBody2D

var MOVE_SPEED = 300
var attack = 10
var direction_speed = 0;

func _init(var path = 0):
	direction_speed = path
	
	#sets attack damage and damage cap
	attack = attack + (3 * GameManager.numPowerUps) #Powerups are permanent.
	if attack > 151 + 5 * GameManager.level:
		attack = 150 + 5 * GameManager.level
	if GameManager.hasPowerUp:
		attack = 2 * attack / 3 + 1
	
	add_to_group("player-bullets")

func _physics_process(delta):
	move_and_collide(Vector2.UP * delta * MOVE_SPEED)
	move_and_collide(Vector2.RIGHT * delta * direction_speed)

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
		
