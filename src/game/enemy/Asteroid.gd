extends KinematicBody2D

onready var Explosion = preload("res://src/game/enemy/explosion/Explosion.tscn")	
onready var HPBar: ProgressBar = $HPBar

# Sound Effect
onready var hurtSoundEffect = AudioStreamPlayer.new()

var max_hp = 150
var hp = max_hp
var moveSpeed = 25
var attack = 10

var isInGame = false

func _ready():
	add_to_group("enemies")
	self.add_child(hurtSoundEffect)
	hurtSoundEffect.stream = load("res://assets/SoundEffect/explosion2.mp3")
	max_hp = max_hp + (35 * (GameManager.level))
	hp = max_hp
	attack = attack + (2 * GameManager.level)
	update_hp_bar()

func _physics_process(delta):
	on_physics_process(delta)

func on_physics_process(delta):
	move_and_collide(Vector2.DOWN * delta * moveSpeed)


func kill():
	queue_free()
	var explosion = Explosion.instance()
	explosion.position = position
	get_parent().add_child(explosion)


func hurt(damage):
	hurtSoundEffect.volume_db = -5
	hurtSoundEffect.play()
	hp -= damage
	update_hp_bar()

	if hp <= 0:		
		kill()

func onExitedBody(body):
	if body.name == "Wall":
		if isInGame:
			isInGame = false
			queue_free()
		else:
			isInGame = true

func update_hp_bar():
	HPBar.value = round(float(hp) / max_hp * 100)
