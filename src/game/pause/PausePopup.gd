extends Popup

onready var Background = $Background
onready var Menu = $Menu
onready var CountDown = $CountDown

func _ready():
	hide()
	Background.hide()
	Menu.hide()
	CountDown.hide()

func _input(event):
	if !get_tree().paused:
		if !visible and Input.is_action_just_pressed("ui_cancel"):
			pause()

func pause():
		get_tree().paused = true
		Background.show()
		Menu.setSelectedMenu(0)
		Menu.show()
		CountDown.hide()
		self.show()
