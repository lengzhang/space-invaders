extends KinematicBody2D

const SPEED = 250
const FIRE_COOL_DOWN = 0.2
const DURATION_POWERUP = 15
const MAX_BARRIER_COUNT = 3

const BULLET_POWER = "res://src/game/player/bullets/Power.tscn"
const BULLET_SUPERPOWER = "res://src/game/player/bullets/SuperPower.tscn"
const BULLET_SHOT = "res://src/game/player/bullets/Shot.tscn"
const BULLET_SUPERSHOT = "res://src/game/player/bullets/SuperShot.tscn"

onready var Explosion = preload("res://src/game/player/explosion/Explosion.tscn")

onready var Player = $"."
onready var Ship = $"Ship"
onready var HurtBox = $HurtBox
onready var Barrier = $Barrier
onready var BarrierShape = $HurtBox/Barrier

onready var shipMode = 0
onready var switchCoolDown = 0
onready var maxHealth = 100

onready var Velocity = Vector2()
onready var fireCoolDown = FIRE_COOL_DOWN
onready var powerUpTimeLeft = 0
onready var powerUpBonusTimeLeft = 0

# Sound Effect
onready var fireSoundEffect = AudioStreamPlayer.new()
onready var healSoundEffect = AudioStreamPlayer.new()
onready var hurtSoundEffect = AudioStreamPlayer.new()

onready var barrier_count = 0

func _ready():
	update_barrier()
	self.add_child(fireSoundEffect)
	fireSoundEffect.stream = load("res://assets/SoundEffect/shoot23.mp3")
	self.add_child(healSoundEffect)
	healSoundEffect.stream = load("res://assets/SoundEffect/upgrade1.wav")
	self.add_child(hurtSoundEffect)
	hurtSoundEffect.stream = load("res://assets/SoundEffect/Blink1.wav")

func _physics_process(delta):
	# Move Left or Right
	if Input.is_action_pressed("ui_left"):
		Velocity.x = -SPEED
	elif Input.is_action_pressed("ui_right"):
		Velocity.x = SPEED
	elif Velocity.x != 0:
		if (Velocity.x > 0):
			var newX = Velocity.x - SPEED
			Velocity.x = max(newX, 0);
		else:
			var newX = Velocity.x + SPEED
			Velocity.x = min(newX, 0);
	# Move Up or Down
	if Input.is_action_pressed("ui_up"):
		Velocity.y = -SPEED
	elif Input.is_action_pressed("ui_down"):
		Velocity.y = SPEED
	elif Velocity.y != 0:
		if (Velocity.y > 0):
			var newY = Velocity.y - SPEED
			Velocity.y = max(newY, 0);
		else:
			var newY = Velocity.y + SPEED
			Velocity.y = min(newY, 0);
		
	move_and_slide(Velocity, Vector2(0, -1))
	
	# Fire
	fireCoolDown += delta	
	if Input.is_action_pressed("ui_accept") and fireCoolDown >= FIRE_COOL_DOWN:
		fire()
		fireCoolDown = 0
		
	# Increase 1 energy every second
	GameManager.energy += delta
	# Active barriers
	if GameManager.energy >= 50 and barrier_count < MAX_BARRIER_COUNT and Input.is_action_just_pressed("ship_barrier"):
		GameManager.energy -= 50
		GameManager.energy = min(GameManager.energy, GameManager.max_energy)
		barrier_count = MAX_BARRIER_COUNT
		update_barrier()
		
	# Timer for Damage PowerUp
	powerUpBonusTimeLeft += delta
	if GameManager.hasPowerUp:
		powerUpTimeLeft += delta
		if DURATION_POWERUP <= powerUpTimeLeft:
			GameManager.hasPowerUp = false
	if DURATION_POWERUP - 5 <= powerUpBonusTimeLeft:
		if GameManager.multiShotBonus > 2:
			powerUpBonusTimeLeft = 0
			GameManager.multiShotBonus = GameManager.multiShotBonus - 1


func onAreaEntered(area):
	if area.get_parent().is_in_group("enemies"):
		var enemy = area.get_parent()
		hurt(enemy.attack)
	if area.get_parent().is_in_group("HPUp"):
		var powerup = area.get_parent()
		heal(powerup.HEALTH_BOOST)
		powerup.destroy()
	if area.get_parent().is_in_group("SuperShot"):
		healSoundEffect.play()
		var powerup = area.get_parent()
		if GameManager.multiShotBonus < 8:
			GameManager.multiShotBonus = GameManager.multiShotBonus + 1 #spawn cap limit is 8
		powerUpBonusTimeLeft = 0 #resets multishot bonus counter
		powerUpTimeLeft = 0
		GameManager.hasPowerUp = true
		powerup.destroy()
	if area.get_parent().is_in_group("PowerUp"):
		healSoundEffect.play()
		var powerup = area.get_parent()
		GameManager.numPowerUps = GameManager.numPowerUps + 1
		powerup.destroy()

func fire():
	fireSoundEffect.volume_db = -5
	fireSoundEffect.play()
	var bullet
	var firedBullet
	var bulletOffset
	var totalOffset
	if GameManager.hasPowerUp:
		if GameManager.multiShotBonus <= 4:
			for n in range(0,GameManager.multiShotBonus):
				bulletOffset = (GameManager.multiShotBonus - 1) * 25
				totalOffset = n * 50 - bulletOffset
				bullet = preload(BULLET_POWER) if shipMode == 0 else preload(BULLET_SHOT)
				firedBullet = bullet.instance()
				firedBullet._init(totalOffset)
				firedBullet.position = Vector2(position.x, position.y - 24)
				get_parent().call_deferred("add_child", firedBullet)
		elif GameManager.multiShotBonus <= 5:
			for n in range(0,GameManager.multiShotBonus):
				bulletOffset = (GameManager.multiShotBonus - 1) * 25
				totalOffset = n * 50 - bulletOffset
				if n == 2:
					bullet = preload(BULLET_SUPERPOWER) if shipMode == 0 else preload(BULLET_SUPERSHOT)
				else:
					bullet = preload(BULLET_POWER) if shipMode == 0 else preload(BULLET_SHOT)
				firedBullet = bullet.instance()
				firedBullet._init(totalOffset)
				firedBullet.position = Vector2(position.x, position.y - 24)
				get_parent().call_deferred("add_child", firedBullet)
		elif GameManager.multiShotBonus <= 6:
			for n in range(0,GameManager.multiShotBonus):
				bulletOffset = (GameManager.multiShotBonus - 1) * 25
				totalOffset = n * 50 - bulletOffset
				if n == 1 || n == 4:
					bullet = preload(BULLET_SUPERPOWER) if shipMode == 0 else preload(BULLET_SUPERSHOT)
				else:
					bullet = preload(BULLET_POWER) if shipMode == 0 else preload(BULLET_SHOT)
				firedBullet = bullet.instance()
				firedBullet._init(totalOffset)
				firedBullet.position = Vector2(position.x, position.y - 24)
				get_parent().call_deferred("add_child", firedBullet)
		elif GameManager.multiShotBonus <= 7:
			for n in range(0,GameManager.multiShotBonus):
				bulletOffset = (GameManager.multiShotBonus - 1) * 25
				totalOffset = n * 50 - bulletOffset
				if n == 1 || n == 3 || n == 5:
					bullet = preload(BULLET_SUPERPOWER) if shipMode == 0 else preload(BULLET_SUPERSHOT)
				else:
					bullet = preload(BULLET_POWER) if shipMode == 0 else preload(BULLET_SHOT)
				firedBullet = bullet.instance()
				firedBullet._init(totalOffset)
				firedBullet.position = Vector2(position.x, position.y - 24)
				get_parent().call_deferred("add_child", firedBullet)
		else:
			for n in range(0,GameManager.multiShotBonus):
				bulletOffset = (GameManager.multiShotBonus - 1) * 25
				totalOffset = n * 50 - bulletOffset
				if n == 2 || n == 3 || n == 4 || n == 5:
					bullet = preload(BULLET_SUPERPOWER) if shipMode == 0 else preload(BULLET_SUPERSHOT)
				else:
					bullet = preload(BULLET_POWER) if shipMode == 0 else preload(BULLET_SHOT)
				firedBullet = bullet.instance()
				firedBullet._init(totalOffset)
				firedBullet.position = Vector2(position.x, position.y - 24)
				get_parent().call_deferred("add_child", firedBullet)
	else:
		bullet = preload(BULLET_POWER) if shipMode == 0 else preload(BULLET_SHOT)
		firedBullet = bullet.instance()
		firedBullet.position = Vector2(position.x, position.y - 24)
		get_parent().call_deferred("add_child", firedBullet)
	
func hurt(damage, ignore_barrier = false):
	if barrier_count <= 0 or ignore_barrier:
		GameManager.hp -= damage
		GameManager.hp = max(GameManager.hp, 0)
	else:
		barrier_count -= 1
		update_barrier()
		
	hurtSoundEffect.volume_db = 10
	hurtSoundEffect.play()
	get_parent().shake()
	if GameManager.hp <= 0:
		var explosion = Explosion.instance()
		explosion.position = position
		hide()
		get_parent().add_child(explosion)
	
func heal(health):
	healSoundEffect.play()
	GameManager.hp = min(GameManager.hp + health, GameManager.max_hp)

func update_barrier():
	#Update sprite
	if barrier_count > 0:
		Barrier.show()
		Barrier.self_modulate = (
			Color.red if barrier_count == 1
			else Color.orange if barrier_count == 2
			else Color.yellow
		)
		BarrierShape.show()
	else:
		Barrier.hide()
		BarrierShape.hide()
#	# Update sprites
#	for i in range(0, Barriers.size()):
#		if i <= barrier_count - 1:
#			Barriers[i].show()
#		else:
#			Barriers[i].hide()
#	# Update hurt box shapes
#	for i in range(0, HurtBoxShapes.size()):
#		if i == barrier_count:
#			HurtBoxShapes[i].show()
#		else:
#			HurtBoxShapes[i].hide()
