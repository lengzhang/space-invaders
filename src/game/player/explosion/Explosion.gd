extends AnimatedSprite

onready var animated_sprite = $"."

var animations = ["explosion_0", "explosion_1", "explosion_2"]

var index = 0

func _ready():
	play_animation()

func _on_Explosion_animation_finished():
	play_animation()

func play_animation():
	if index < animations.size():
		animated_sprite.play(animations[index])
		index += 1
	else:
		queue_free()
		get_parent().game_over()
