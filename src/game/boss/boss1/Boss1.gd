extends KinematicBody2D

const MOVE_SPEED = 50
const OFFSET_Y = 75
const MAX_HP = 5000
const FIRE_WIN_COUNT = 8

const WAVES = [
	[0.5, [
		[-1, -1, -1, -1, -1, -1, -1, -1],
		[-1, -1, -1, -1, -1, -1, -1, -1],
		[-1, -1, -1, 0, 0, -1, -1, -1],
		[-1, -1, 0, -1, -1, 0, -1, -1],
		[-1, 0, -1, -1, -1, -1, 0, -1],
		[0, -1, -1, -1, -1, -1, -1, 0],
		[-1, 0, -1, -1, -1, -1, -1, -1],
		[-1, -1, 0, -1, -1, -1, -1, -1],
		[-1, -1, -1, 0, -1, -1, -1, -1],
		[-1, -1, -1, -1, 0, -1, -1, -1],
		[-1, -1, -1, -1, -1, 0, -1, -1],
		[-1, -1, -1, -1, -1, -1, 0, -1],
		[-1, -1, -1, -1, -1, -1, -1, 0],
		[-1, -1, -1, -1, -1, 0, 0, 0],
		[-1, -1, -1, -1, -1, 0, 0, 0],
		[-1, -1, -1, -1, -1, 0, 0, 0],
		[0, 0, 0, -1, -1, -1, -1, -1],
		[0, 0, 0, -1, -1, -1, -1, -1],
		[0, 0, 0, -1, -1, -1, -1, -1],
		[-1, -1, 0, 0, 0, 0, -1, -1],
		[-1, -1, 0, 0, 0, 0, -1, -1],
		[-1, -1, 0, 0, 0, 0, -1, -1],
	]],
	[0.5, [
		[-1, -1, -1, -1, -1, -1, -1, -1],
		[-1, -1, -1, -1, -1, -1, -1, -1],
		[-1, -1, -1, 1, 1, -1, -1, -1],
		[-1, -1, -1, -1, -1, -1, -1, -1],
		[-1, -1, 1, -1, -1, 1, -1, -1],
		[-1, -1, -1, -1, -1, -1, -1, -1],
		[-1, 1, -1, -1, -1, -1, 1, -1],
		[-1, -1, -1, -1, -1, -1, -1, -1],
		[1, -1, -1, -1, -1, -1, -1, 1],
		[-1, -1, -1, -1, -1, -1, -1, -1],
		[1, 1, 1, 1, 1, -1, -1, -1],
		[-1, -1, -1, -1, -1, -1, -1, -1],
		[-1, -1, -1, 1, 1, 1, 1, 1],
	]],
	[0.5, [
		[-1, -1, -1, -1, -1, -1, -1, -1],
		[-1, -1, -1, -1, -1, -1, -1, -1],
		[0, 0, 0, 0, 0, 0, 0, 0],
		[-1, -1, -1, -1, -1, -1, -1, -1],
		[0, 0, 0, 0, 1, 1, 1, 1],
		[-1, -1, -1, -1, -1, -1, -1, -1],
		[1, 1, 1, 1, 0, 0, 0, 0],
	]]
]

onready var Explosion = preload("res://src/game/boss/explosion/Explosion.tscn")

onready var Warning = preload("res://src/game/Warning.tscn")
onready var warning = Warning.instance()

onready var bullets = [
	preload("res://src/game/boss/bullet/bullet1/Bullet1.tscn"),
	preload("res://src/game/boss/bullet/bullet2/Bullet2.tscn")
]

onready var viewport_size = get_viewport_rect().size

# Sound Effect
onready var hurtSoundEffect = AudioStreamPlayer.new()

onready var Parent = get_parent()
onready var BossSprite = $AnimatedSprite
onready var HitBox = $HitBox
onready var HPBar = $HPBar

onready var default_sacle = BossSprite.scale
onready var max_hp = MAX_HP + (15 * (GameManager.level-1))
onready var hp = max_hp
onready var attack = 1000 + (50 * GameManager.level)

var stage = 0
var waves_index = 0
var fire_cooldown = 0

var fire_positions = []

func _ready():
	warning = Warning.instance()
	warning.position = viewport_size / 2
	get_parent().add_child(warning)
	
	position.x = viewport_size.x / 2
	position.y = -OFFSET_Y * 2
	BossSprite.scale.x = 1
	BossSprite.scale.y = 1
	
	var fire_win_size = viewport_size.x / FIRE_WIN_COUNT
	for i in range(0, FIRE_WIN_COUNT):
		fire_positions.push_back([fire_win_size * i + fire_win_size / 2, OFFSET_Y * 2])
	HitBox.hide()
	HPBar.hide()
	update_hp_bar()
	
	add_to_group("enemies")
	self.add_child(hurtSoundEffect)
	hurtSoundEffect.stream = load("res://assets/SoundEffect/explosion2.mp3")
	
func _physics_process(delta):
	if weakref(warning).get_ref():
		var changed = false
		if position.y < OFFSET_Y:
			var next = Vector2.DOWN * delta * MOVE_SPEED
			next.y = min(next.y, OFFSET_Y)
			move_and_collide(next)
			changed = true

		if position.y > -OFFSET_Y / 2 and (BossSprite.scale.x > default_sacle.x or BossSprite.scale.y > default_sacle.y):
			BossSprite.scale.x = max(BossSprite.scale.x - delta * (1 - default_sacle.x) / 2, default_sacle.x)
			BossSprite.scale.y = max(BossSprite.scale.y - delta * (1 - default_sacle.y) / 2, default_sacle.y)
			changed = true
			
		if !changed and weakref(warning).get_ref():
			warning.queue_free()
			HitBox.show()
			HPBar.show()
			stage = 0
			waves_index = 0
			fire_cooldown = 0
	else:
		fire_cooldown += delta
		process_fire()

func process_fire():
	var damage_percent = (max_hp - hp) / float(max_hp)
	var new_stage = (
		0 if damage_percent < 0.25
		else 1 if damage_percent < 0.8
		else 2
	)
	if stage != new_stage:
		stage = new_stage
		waves_index = 0
		
	if fire_cooldown >= WAVES[stage][0]:
		var waves = WAVES[stage][1]
		var wave = waves[waves_index]
		fire_cooldown = 0
		for i in range(0, fire_positions.size()):
			var bullet_index = wave[i]
			if bullet_index < 0: continue
			var bullet = bullets[bullet_index].instance()
			bullet.position.x = fire_positions[i][0]
			bullet.position.y = fire_positions[i][1]
			Parent.add_child(bullet)
		waves_index += 1
		if waves_index >= waves.size():
			waves_index = 0

func kill():
	var explosion = Explosion.instance()
	explosion.position = position
	queue_free()
	get_parent().add_child(explosion)
	
func hurt(damage):
	if HitBox.is_visible_in_tree():
		hurtSoundEffect.volume_db = -5
		hurtSoundEffect.play()
		hp -= damage
		update_hp_bar()

		if hp <= 0:		
			kill()
			if Parent.has_method("increaseScore"):
				Parent.increaseScore(max_hp)
			
func update_hp_bar():
	HPBar.value = round(float(hp) / max_hp * 100)
