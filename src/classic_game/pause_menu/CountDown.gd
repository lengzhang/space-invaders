extends Label

onready var PausePopup = $"../../"

var countDown = 3

func _ready():
	hide()

func _process(delta):
	if get_tree().paused:
		if !visible:
			countDown = 3
		else:
			countDown -= delta
		
		if countDown <= 0:
			PausePopup.hide()
			get_tree().paused = false
		else:
			text = String(ceil(countDown))
