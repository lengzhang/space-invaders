extends KinematicBody2D


var bulletSpeed = 100
const attack = 10

onready var parent = get_parent()

onready var destoryable = true

func _ready():
	var randomNumberGenerator = RandomNumberGenerator.new()
	randomNumberGenerator.randomize()
	destoryable = randomNumberGenerator.randi_range(0, 2) != 2
	bulletSpeed = bulletSpeed + (15 * GameManager.level)
	add_to_group("enemy-bullets")
	$Sprite.frame  = (
		15 if destoryable
		else 11
	)

func _physics_process(delta):
	move_and_collide(Vector2.DOWN * delta * bulletSpeed)

func hurt():
	if destoryable:
		if parent.has_method("increaseScore"):
			parent.increaseScore(1)
		destroy()
	
func destroy():
	queue_free()

func _on_HitBox_area_entered(area):
	var parent = area.get_parent()
	if parent.name == "Player":
		parent.hurt(attack)
		destroy()
