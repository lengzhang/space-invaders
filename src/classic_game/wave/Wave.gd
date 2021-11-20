extends Node

const MOVE_SPEED_RATE = 1
const MOVE_SPEED_RATE_STEP = 0.1

onready var Parent = $"../"
onready var level = Parent.level

var enemies = {}

var enemy_cout = 0
var enemy_kills = 0
var move_speed_rate = MOVE_SPEED_RATE
var move_speed_rate_step = MOVE_SPEED_RATE_STEP

# Called when the node enters the scene tree for the first time.
func _ready():
	move_speed_rate_step = MOVE_SPEED_RATE_STEP * level
	move_speed_rate = MOVE_SPEED_RATE + move_speed_rate_step


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func add_enemy():
	enemy_cout += 1

func remove_enemy(type):
	enemy_cout -= 1
	enemy_kills += 1

	Parent.add_score(type)
	if enemy_kills % 3 == 0:
		move_speed_rate += move_speed_rate_step
	if enemy_cout == 0:
		Parent.next_level()
