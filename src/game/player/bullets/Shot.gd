extends KinematicBody2D

const MOVE_SPEED = 300
const MAX_HIT_COUNT = 3

var attack = 5

var hitCount = MAX_HIT_COUNT
var direction_speed = 0;

func _init(var path = 0):
	direction_speed = path
	
	#Sets damage stats and damage cap.
	attack = attack + (1 * GameManager.numPowerUps) #Powerups are permanent.
	if attack > 51 + 2 * GameManager.level:
		attack = 50 + 2 * GameManager.level
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
		hitCount -= 1
	elif parent.is_in_group("enemy-bullets"):
		parent.hurt()
		hitCount -= 1
		
	if hitCount <= 0:
		queue_free()
