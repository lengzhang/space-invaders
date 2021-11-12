extends VBoxContainer

const COLOR_UNSELECTED = Color("808080")
const COLOR_SELECTED = Color("64a500")

onready var GameScene = preload("res://src/game/Game.tscn")
onready var HowToPlayScene = preload("res://src/how_to_play/HowToPlay.tscn")


onready var Menu = self
onready var NewGame = $NewGame
onready var HowToPlay = $HowToPlay
onready var Quit = $Quit

const MENU_LENGTH = 3
var selectedMenu = 0

func _ready():
	setSelectedMenu(0)

func _input(event):
	if Input.is_action_just_pressed("ui_up"):
		setSelectedMenu(MENU_LENGTH - 1 if selectedMenu == 0 else selectedMenu - 1)
	elif Input.is_action_just_pressed("ui_down"):
		setSelectedMenu(0if selectedMenu == MENU_LENGTH - 1 else selectedMenu + 1)
	elif Input.is_action_just_pressed("ui_accept"):
		select()
	print(selectedMenu)

func select():
	match selectedMenu:
		# New Game
		0:
			get_tree().change_scene_to(GameScene)
		# How To Play?
		1:
			get_tree().change_scene_to(HowToPlayScene)
		# Quit
		2:
			get_tree().quit()

func setSelectedMenu(index):
	selectedMenu = index
	NewGame.color = COLOR_SELECTED if index == 0 else COLOR_UNSELECTED
	HowToPlay.color = COLOR_SELECTED if index == 1 else COLOR_UNSELECTED
	Quit.color = COLOR_SELECTED if index == 2 else COLOR_UNSELECTED
