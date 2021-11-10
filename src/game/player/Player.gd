extends KinematicBody2D

const SPEED = 250
const FIRE_COOL_DOWN = 0.2

var maxHealth = 100
var hp = 70

var Velocity = Vector2()
var fireCoolDown = FIRE_COOL_DOWN

var isIn = false

func _physics_process(delta):
	
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
	
	
	
	if fireCoolDown < FIRE_COOL_DOWN:
		fireCoolDown += delta
		
	if Input.is_action_pressed("ui_accept") and fireCoolDown >= FIRE_COOL_DOWN:
		fire()
		fireCoolDown = 0
		
	move_and_slide(Velocity, Vector2(0, -1))

func fire():
	var bullet = preload("res://src/game/player/PlayerBullet.tscn")
	var firedBullet = bullet.instance()
	firedBullet.position = Vector2(position.x, position.y - 24)
	get_parent().call_deferred("add_child", firedBullet)
	
func hurt(damage):
	hp -= damage
	hp = max(hp, 0)
	if hp <= 0:
		get_parent().gameOver()

func onAreaEntered(area):
	if area.get_parent().is_in_group("enemies"):
		var enemy = area.get_parent()
		hurt(enemy.attack)
