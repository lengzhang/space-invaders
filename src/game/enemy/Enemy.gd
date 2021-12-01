extends KinematicBody2D

onready var Explosion = preload("res://src/game/enemy/explosion/Explosion.tscn")

onready var Parent = get_parent()
onready var HPBar: ProgressBar = $HPBar

# Sound Effect
onready var hurtSoundEffect = AudioStreamPlayer.new()

var max_hp = 100
var hp = max_hp
var moveSpeed = 25
var attack = 10

var isInGame = false
	
func _ready():
	add_to_group("enemies")
	self.add_child(hurtSoundEffect)
	hurtSoundEffect.stream = load("res://assets/SoundEffect/explosion2.mp3")
	

func _physics_process(delta):
	on_physics_process(delta)
	
	if HPBar.value != hp:
		var diff = hp - HPBar.value
		if diff > 0:
			HPBar.value += max(diff * delta * 10, delta)
			HPBar.value = min(HPBar.value, hp)
		elif diff < 0:
			HPBar.value -= max(-diff * delta * 10, delta)
			HPBar.value = max(HPBar.value, hp)

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

	if hp <= 0:
		GameManager.energy = min(GameManager.energy + 1, GameManager.max_energy)
		kill()
		if Parent.has_method("increaseScore"):
			Parent.increaseScore(max_hp)

func onExitedBody(body):
	if body.name == "Wall":
		if isInGame:
#			if Parent.has_method("hurtPlayer"):
#				Parent.hurtPlayer()
#			isInGame = false
			queue_free()
		else:
			isInGame = true
