extends ProgressBar

onready var Bar = $"."
onready var Percentage = $Value

onready var percentage = GameManager.hp

func _ready():
	update_bar()
	max_value = 100
	value = percentage
	
func _process(delta):
	update_bar()
	var diff = percentage - value
	if diff > 0:
		value += max(diff * delta * 5, delta)
		value = min(value, percentage)
	elif diff < 0:
		value -= max(-diff * delta * 5, delta)
		value = max(value, percentage)
	
func update_bar():
	percentage = min(round(float(GameManager.hp) / GameManager.max_hp * 100), 100)
	Percentage.text = String(percentage)
