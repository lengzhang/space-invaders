extends HBoxContainer

onready var percentage = $Count/Background/percentage
onready var bar = $Gauge


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var maxValue = 100
var value = 100

# Called when the node enters the scene tree for the first time.
func _ready():
	bar.max_value = 100
	setHealth(100)
	

func setHealth(hp):
	value = hp
	bar.value = round(float(hp) / maxValue * 100)
	percentage.text = String(bar.value)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
