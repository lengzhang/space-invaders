extends KinematicBody2D

const MAX_HP = 100


onready var parent = get_parent()

# Sound Effect
onready var hurtSoundEffect = AudioStreamPlayer.new()

var hp = MAX_HP
var moveSpeed = 25
var attack = 10


var isInGame = false
	
func _ready():
	add_to_group("enemies")
	isInGame = false
	hp = hp + (15 * (GameManager.level-3))
	moveSpeed = moveSpeed + (10 * GameManager.level)
	attack = attack + (2 * GameManager.level)
	self.add_child(hurtSoundEffect)
	hurtSoundEffect.stream = load("res://assets/SoundEffect/explosion2.mp3")
	

func _physics_process(delta):
	move_and_collide(Vector2.DOWN * delta * moveSpeed)
	

func kill():
	queue_free()


func hurt(damage):
	hurtSoundEffect.volume_db = -5
	hurtSoundEffect.play()
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
