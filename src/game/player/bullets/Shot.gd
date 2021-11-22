extends KinematicBody2D

const MOVE_SPEED = 300
const MAX_HIT_COUNT = 3

var attack = 5

var hitCount = MAX_HIT_COUNT
var direction: String

func _init(path = "middle"):
	direction = path
	
	#Sets damage stats and damage cap.
	attack = attack + (1 * GameManager.numPowerUps) #Powerups are permanent.
	if attack > 51:
		attack = 50
	
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
		hitCount -= 1
	elif parent.is_in_group("enemy-bullets"):
		parent.hurt()
		hitCount -= 1
		
	if hitCount <= 0:
		queue_free()
