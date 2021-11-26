extends KinematicBody2D

const SPEED = 250
const FIRE_COOL_DOWN = 0.2
const DURATION_POWERUP = 15

const SHIP_TEXTURE_0 = "res://assets/spaceshooter_ByJanaChumi/items/16.png"
const SHIP_TEXTURE_1 = "res://assets/spaceshooter_ByJanaChumi/items/17.png"

const BULLET_POWER = "res://src/game/player/bullets/Power.tscn"
const BULLET_SHOT = "res://src/game/player/bullets/Shot.tscn"

onready var Explosion = preload("res://src/game/player/explosion/Explosion.tscn")

onready var Player = $"."
onready var Ship = $"Ship"

onready var shipMode = -1
onready var switchCoolDown = 0
onready var maxHealth = 100
onready var hp = 100

onready var Velocity = Vector2()
onready var fireCoolDown = FIRE_COOL_DOWN
onready var powerUpTimeLeft = 0
onready var powerUpBonusTimeLeft = 0

# Sound Effect
onready var fireSoundEffect = AudioStreamPlayer.new()
onready var healSoundEffect = AudioStreamPlayer.new()
onready var hurtSoundEffect = AudioStreamPlayer.new()

func _ready():
	setShipMode(0)
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
		
	# Ship Switch
	switchCoolDown += delta
	if Input.is_action_just_pressed("ship_switch") and switchCoolDown >= 1:
		setShipMode(0 if shipMode == 1 else 1)
		switchCoolDown = 0
		
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
		for n in range(0,GameManager.multiShotBonus):
			bulletOffset = (GameManager.multiShotBonus - 1) * 25
			totalOffset = n * 50 - bulletOffset
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
	
func hurt(damage):
	hurtSoundEffect.volume_db = 10
	hurtSoundEffect.play()
	hp -= damage
	get_parent().shake()
	hp = max(hp, 0)
	if hp <= 0:
		var explosion = Explosion.instance()
		explosion.position = position
		queue_free()
		get_parent().add_child(explosion)
	
func heal(health):
	healSoundEffect.play()
	hp += health
	if hp >= maxHealth:
		hp = maxHealth


func setShipMode(mode):
	if mode != shipMode:
		shipMode = mode
		Ship.texture = preload(SHIP_TEXTURE_0) if shipMode == 0 else preload(SHIP_TEXTURE_1)
