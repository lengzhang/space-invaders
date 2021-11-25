extends AnimatedSprite

onready var animated_sprite = $"."

onready var Classic_invadersKilled = AudioStreamPlayer.new()

func _ready():
	animated_sprite.play("explosion")
	self.add_child(Classic_invadersKilled)
	Classic_invadersKilled.stream = load("res://assets/SoundEffect/Classic_invaderkilled.wav")
	Classic_invadersKilled.volume_db = -10
	Classic_invadersKilled.play()

func _on_Explosion_animation_finished():
	queue_free()
