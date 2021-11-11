extends KinematicBody2D

const SPEED = 250
const FIRE_COOL_DOWN = 0.2

const SHIP_TEXTURE_0 = "res://assets/spaceshooter_ByJanaChumi/items/16.png"
const SHIP_TEXTURE_1 = "res://assets/spaceshooter_ByJanaChumi/items/17.png"

const BULLET_POWER = "res://src/game/player/bullets/Power.tscn"
const BULLET_SHOT = "res://src/game/player/bullets/Shot.tscn"

onready var Player = $"."
onready var Ship = $"Ship"

onready var shipMode = -1
onready var maxHealth = 100
onready var hp = 100

onready var Velocity = Vector2()
onready var fireCoolDown = FIRE_COOL_DOWN

var isIn = false

func _ready():
	setShipMode(0)

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
	if fireCoolDown < FIRE_COOL_DOWN:
		fireCoolDown += delta
		
	if Input.is_action_pressed("ui_accept") and fireCoolDown >= FIRE_COOL_DOWN:
		fire()
		fireCoolDown = 0
		
	# Ship Switch
	if Input.is_action_just_pressed("ship_switch"):
		setShipMode(0 if shipMode == 1 else 1)

func onAreaEntered(area):
	if area.get_parent().is_in_group("enemies"):
		var enemy = area.get_parent()
		hurt(enemy.attack)

func fire():
	var bullet = preload(BULLET_POWER) if shipMode == 0 else preload(BULLET_SHOT)
	var firedBullet = bullet.instance()
	firedBullet.position = Vector2(position.x, position.y - 24)
	get_parent().call_deferred("add_child", firedBullet)
	
func hurt(damage):
	hp -= damage
	hp = max(hp, 0)
	if hp <= 0:
		get_parent().gameOver()

func setShipMode(mode):
	if mode != shipMode:
		shipMode = mode
		Ship.texture = preload(SHIP_TEXTURE_0) if shipMode == 0 else preload(SHIP_TEXTURE_1)
