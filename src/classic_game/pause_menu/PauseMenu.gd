extends Popup

onready var Parent = get_parent()
onready var Background = $Container/Background
onready var Menu = $Container/Menu
onready var CountDown = $Container/CountDown

func _ready():
	hide()
	Background.hide()
	Menu.hide()
	CountDown.hide()

func _input(event):
	if !get_tree().paused and Parent.is_able_to_pause:
		if !visible and Input.is_action_just_pressed("ui_cancel"):
			pause()

func pause():
	print('pause')
	get_tree().paused = true
	Background.show()
	Menu.setSelectedMenu(0)
	Menu.show()
	CountDown.hide()
	self.show()
