extends KinematicBody2D

const MOVE_SPEED = 700

onready var animated_sprite = $AnimatedSprite

func _ready():
	animated_sprite.play("run")

func _process(delta):
	move_and_collide(Vector2.UP * delta * MOVE_SPEED)

func _on_HurtBox_area_entered(area):
	var parent = area.get_parent()

	if parent.is_in_group("enemies"):
		parent.hurt()
		queue_free()
	elif parent.is_in_group("enemy_bullet"):
		parent.destory()
		queue_free()
