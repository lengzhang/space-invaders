extends ProgressBar

onready var percentage = $Value

var maxHPValue = 100
var hpValue = 100

func _ready():
	max_value = maxHPValue
	setHealth(100)
	
func setHealth(hp):
	hpValue = hp
	value = round(float(hp) / maxHPValue * 100)
	percentage.text = String(value)


func onPressed():
	pass # Replace with function body.
