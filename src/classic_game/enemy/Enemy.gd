extends KinematicBody2D

const MOVE_SPEED = 100
const POSITION_OFFSET_X = 96
const POSITION_OFFSET_Y = 32

onready var Wave = $"../../"
onready var animated_sprite = $AnimatedSprite
onready var viewport_size = get_viewport_rect().size

onready var direction = Vector2.LEFT

onready var offset_x = 0
onready var offset_y = 0

onready var type = 0

func _ready():
	animated_sprite.play("run")
	Wave.add_enemy()

func _physics_process(delta):
	if direction == Vector2.LEFT and offset_x <= -POSITION_OFFSET_X:
		direction = Vector2.RIGHT
	elif direction == Vector2.RIGHT and offset_x >= POSITION_OFFSET_X:
		direction = Vector2.DOWN
		offset_y = 0
	elif direction == Vector2.DOWN and offset_y >= POSITION_OFFSET_Y:
		direction = Vector2.LEFT
	
	var next = direction * delta * MOVE_SPEED * Wave.move_speed_rate
	move_and_collide(next)
	if direction == Vector2.LEFT or direction == Vector2.RIGHT:
		offset_x += next[0]
	elif direction == Vector2.DOWN:
		offset_y += next[1]

func hurt():
	Wave.remove_enemy(type)
	queue_free()
