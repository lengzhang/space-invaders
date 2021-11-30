extends KinematicBody2D

const ROTATE_SPEED = 2 * PI / 360 * 180
const MOVE_RADIO_SPEED = 10
const MAX_RADIO = 50

var bulletSpeed = 100
const attack = 10

onready var Parent = get_parent().get_parent()

onready var angle = 0
onready var radio = 0

var destoryable = true

func _ready():
	bulletSpeed = bulletSpeed + (15 * GameManager.level)
	add_to_group("enemy-bullets")
	radio = sqrt(pow(position.x, 2) + pow(position.y, 2))
	angle = atan2(position.y, position.x)


func _physics_process(delta):
	angle += ROTATE_SPEED * delta
	radio += MOVE_RADIO_SPEED * delta
	if radio > MAX_RADIO:
		radio = MAX_RADIO
	position.x = cos(angle) * radio
	position.y = sin(angle) * radio

func hurt():
	if destoryable:
		if Parent.has_method("increaseScore"):
			Parent.increaseScore(1)
		destroy()
	
func destroy():
	queue_free()

func _on_HitBox_area_entered(area):
	var parent = area.get_parent()
	if parent.name == "Player":
		parent.hurt(attack)
		destroy()

func set_destoryable(value):
	self.destoryable = value
	$Sprite.frame = (
		15 if self.destoryable
		else 14
	)
	
