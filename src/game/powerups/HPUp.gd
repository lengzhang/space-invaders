extends KinematicBody2D

const MOVE_SPEED = 100
const HEALTH_BOOST = 25

const PLAYER_STATS = "res://assets/spaceshooter_ByJanaChumi/items/31.png"

onready var parent = get_parent()

var isInGame = false
	
func _ready():
	add_to_group("HPUp")
	isInGame = false

func _physics_process(delta):
	move_and_collide(Vector2.DOWN * delta * MOVE_SPEED)

func destroy():
	queue_free()


#func onEnteredArea(area):
#	var parent = area.get_parent()
#	if parent.name == "Player":
#		parent.heal(HEALTH_BOOST)
#		destroy()
