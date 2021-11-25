extends AnimatedSprite

onready var animated_sprite = $"."

onready var Classic_Dead = AudioStreamPlayer.new()

func _ready():
	animated_sprite.play("explosion")
	self.add_child(Classic_Dead)
	Classic_Dead.stream = load("res://assets/SoundEffect/Classic_death3.wav")
	Classic_Dead.volume_db = -10
	Classic_Dead.play()

func _on_Dead_animation_finished():
	queue_free()
	get_parent().plane_dead()
