extends VBoxContainer

const COLOR_UNSELECTED = Color("808080")
const COLOR_SELECTED = Color("64a500")

onready var Background = $"../Background"
onready var Menu = self
onready var CountDown = $"../CountDown"

onready var selections = [$Resume, $Quit]
onready var menu_length = selections.size()

# Sound Effect
onready var soundEffect = AudioStreamPlayer.new()

var counter = 0

var selectedMenu = 0


func _ready():
	self.add_child(soundEffect)
	soundEffect.stream = load("res://assets/SoundEffect/select7.wav")

func _input(event):

	if get_tree().paused:
		if !visible:
			if Input.is_action_just_pressed("ui_cancel"):
				selectedMenu = 0
				get_tree().paused = true
		else:
			if Input.is_action_just_pressed("ui_up"):
				setSelectedMenu(menu_length - 1 if selectedMenu == 0 else selectedMenu - 1)
			elif Input.is_action_just_pressed("ui_down"):
				setSelectedMenu(0 if selectedMenu == menu_length - 1 else selectedMenu + 1)
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
		# Quit
		1:
			get_tree().paused = false
			get_tree().change_scene("res://src/main_menu/MainMenu.tscn")

func setSelectedMenu(index):
	if counter >= 1:
			soundEffect.play()
	counter += 1
	selectedMenu = index
	
	for i in selections.size():
		selections[i].color = COLOR_SELECTED if index == i else COLOR_UNSELECTED
