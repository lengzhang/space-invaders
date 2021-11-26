extends AnimatedSprite

var randomNumberGenerator = RandomNumberGenerator.new()

onready var animated_sprite = $"."

# Sound Effect
onready var hurtSoundEffect = AudioStreamPlayer.new()

const animations = ["explosion_0", "explosion_1", "explosion_2", "explosion_3"]

func _ready():
	randomNumberGenerator.randomize()
	var i = randomNumberGenerator.randi_range(0, 3)
	if i == 0:
		animated_sprite.scale.x = 1
		animated_sprite.scale.y = 1
	animated_sprite.play(animations[i])
	self.add_child(hurtSoundEffect)
	hurtSoundEffect.stream = load("res://assets/SoundEffect/Blink33.wav")
#	hurtSoundEffect.volume_db = -10
	hurtSoundEffect.play()

func _on_Explosion_animation_finished():
	queue_free()
