extends KinematicBody2D

const MOVE_SPEED = 150
const VIEWPOINT_OFFSET_X = 16
const VIEWPOINT_OFFSET_Y = 56
const FIRE_COOL_DOWN = 1
const JUST_FIRE_COOL_DOWN = 0.75

onready var wave = $"../../"
onready var animated_sprite = $AnimatedSprite
onready var viewport_size = get_viewport_rect().size

onready var BULLET = preload("res://src/classic_game/plane/Bullet.tscn")
onready var Dead = preload("res://src/classic_game/plane/Dead.tscn")

onready var fireCoolDown = FIRE_COOL_DOWN / 2
onready var justFireCoolDown = JUST_FIRE_COOL_DOWN / 2

onready var ready = false
onready var is_go_forward = false

# Sound Effect
onready var Classic_Fire = AudioStreamPlayer.new()
onready var Classic_Hurt = AudioStreamPlayer.new()

func _ready():
	self.add_child(Classic_Fire)
	Classic_Fire.stream = load("res://assets/SoundEffect/Classic_shoot.wav")
	self.add_child(Classic_Hurt)
	Classic_Hurt.stream = load("res://assets/SoundEffect/Classic_death3.wav")

func _physics_process(delta):
	if !ready:
		var next = Vector2.UP * delta * MOVE_SPEED
		var next_position = position[1] + next[1]
		if next_position <= viewport_size[1] - VIEWPOINT_OFFSET_Y:
			next[1] = viewport_size[1] - VIEWPOINT_OFFSET_Y - position[1]
			ready = true
		move_and_collide(next)
	elif is_go_forward:
		if position[1] > 0:
			move_and_collide(Vector2.UP * delta * MOVE_SPEED * 3)
		else:
			queue_free()
	else:
		var next = Vector2()
		if Input.is_action_pressed("ui_left"):
			next = Vector2.LEFT * delta * MOVE_SPEED
		elif Input.is_action_pressed("ui_right"):
			next = Vector2.RIGHT * delta * MOVE_SPEED
		
		var next_position = position[0] + next[0]
		if VIEWPOINT_OFFSET_X < next_position and next_position < viewport_size[0] - VIEWPOINT_OFFSET_X:
			move_and_collide(next)
			
		fireCoolDown += delta
		justFireCoolDown += delta
		if Input.is_action_just_pressed("fire") and justFireCoolDown >= JUST_FIRE_COOL_DOWN:
			fire()
			justFireCoolDown = 0
			fireCoolDown = 0
		elif Input.is_action_pressed("fire") and fireCoolDown >= FIRE_COOL_DOWN:
			fire()
			fireCoolDown = 0
			
func ClassicFire():
	Classic_Fire.volume_db = -10
	Classic_Fire.play()

func fire():
	ClassicFire()
	var firedBullet = BULLET.instance()
	firedBullet.position = Vector2(position.x, position.y - 32)
	get_parent().call_deferred("add_child", firedBullet)

func hurt():
	var dead = Dead.instance()
	dead.position = position
	get_parent().add_child(dead)
	queue_free()
	
func go_forward():
	is_go_forward = true
