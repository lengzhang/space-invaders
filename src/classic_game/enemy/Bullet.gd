extends KinematicBody2D

const MOVE_SPEED = 200
const MOVE_SPEED_STEP = 10

onready var Game = $"../../../"

func _process(delta):
	var speed = MOVE_SPEED + MOVE_SPEED_STEP * (Game.level - 1)
	move_and_collide(Vector2.DOWN * delta * speed)
	
func destory():
	queue_free()

func _on_HitBox_area_entered(area):
	var parent = area.get_parent()
	if parent.is_in_group("plane"):
		parent.hurt()
		queue_free()
