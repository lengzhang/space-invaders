extends VBoxContainer

const COLOR_UNSELECTED = Color("808080")
const COLOR_SELECTED = Color("64a500")

onready var Background = $"../Background"
onready var Menu = self
onready var Resume = $Resume
onready var Restart = $Restart
onready var Quit = $Quit
onready var CountDown = $"../CountDown"

var selectedMenu = 0

func _input(event):

	if get_tree().paused:
		if !visible:
			if Input.is_action_just_pressed("ui_cancel"):
				selectedMenu = 0
				get_tree().paused = true
		else:
			if Input.is_action_just_pressed("ui_up"):
				setSelectedMenu(2 if selectedMenu == 0 else selectedMenu - 1)
			elif Input.is_action_just_pressed("ui_down"):
				setSelectedMenu(0 if selectedMenu == 2 else selectedMenu + 1)
			elif Input.is_action_just_pressed("ui_accept"):
				select()

func select():
	match selectedMenu:
		# Resume
		0:
			Background.hide()
			Menu.hide()
			CountDown.countDown = 3
			CountDown.show()
		# Restart
		1:
			get_tree().paused = false
			get_tree().change_scene("res://src/game/Game.tscn")
		# Quit
		2:
			get_tree().paused = false
			get_tree().change_scene("res://src/main_menu/MainMenu.tscn")

func setSelectedMenu(index):
	selectedMenu = index
	Resume.color = COLOR_SELECTED if index == 0 else COLOR_UNSELECTED
	Restart.color = COLOR_SELECTED if index == 1 else COLOR_UNSELECTED
	Quit.color = COLOR_SELECTED if index == 2 else COLOR_UNSELECTED
