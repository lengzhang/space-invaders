extends KinematicBody2D

const MAX_HP = 100


onready var parent = get_parent()

# Sound Effect
#onready var damageSoundEffect = AudioStreamPlayer.new()

var hp = MAX_HP
var moveSpeed = 25
var attack = 10

var isInGame = false
	
func _ready():
	add_to_group("enemies")
	isInGame = false
	moveSpeed = moveSpeed + (10 * GameManager.level)
	attack = attack + (2 * GameManager.level)
#	self.add_child(damageSoundEffect)
#	damageSoundEffect.stream = load("res://assets/SoundEffect/damage1.mp3")
	

func _physics_process(delta):
	move_and_collide(Vector2.DOWN * delta * moveSpeed)

func kill():
	queue_free()

func hurt(damage):
#	damageSoundEffect.volume_db = -10
#	damageSoundEffect.play()
	hp -= damage

	if hp <= 0:		
		kill()
		if parent.has_method("increaseScore"):
			parent.increaseScore(MAX_HP)

func onExitedBody(body):
	if body.name == "Wall":
		if isInGame:
			isInGame = false
			kill()
		else:
			isInGame = true
