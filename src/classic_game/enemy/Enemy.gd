extends KinematicBody2D

const MOVE_SPEED = 50
const POSITION_OFFSET_X = 96
const POSITION_OFFSET_Y = 32


onready var Wave = $"../../"
onready var animated_sprite = $AnimatedSprite
onready var viewport_size = get_viewport_rect().size

onready var direction = Vector2.LEFT

onready var offset_x = 0
onready var offset_y = 0

onready var type = 0

# Sound Effect
onready var Classic_invadersKilled = AudioStreamPlayer.new()


func _ready():
	animated_sprite.play("run")
	Wave.add_enemy()
	self.add_child(Classic_invadersKilled)
	Classic_invadersKilled.stream = load("res://assets/SoundEffect/Classic_invaderkilled.wav")
	
	
func hurtSound():
	Classic_invadersKilled.volume_db = -10
	Classic_invadersKilled.play()


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
	hurtSound()
	yield(get_tree().create_timer(0.5), "timeout")
	Wave.remove_enemy(type)
	queue_free()
