extends ProgressBar

onready var Bar = $"."
onready var Percentage = $Value
onready var KeyX = $KeyX

onready var percentage = 0

func _ready():
	update_bar()
	max_value = 100
	value = percentage
	
func _process(delta):
	update_bar()
	var diff = percentage - value
	if diff > 0:
		value += max(diff * delta, delta)
		value = min(value, percentage)
	elif diff < 0:
		value -= max(-diff * delta, delta)
		value = max(value, percentage)
	
	
func update_bar():
	percentage = min(round(float(GameManager.energy) / GameManager.max_energy * 100), 100)
	Percentage.text = String(percentage)
	if percentage >= 50:
		KeyX.show()
	else:
		KeyX.hide()
