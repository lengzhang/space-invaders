extends VBoxContainer

const COLOR_UNSELECTED = Color("808080")
const COLOR_SELECTED = Color("64a500")
const COLOR_RED = Color("ff4444")

onready var GameScene = preload("res://src/game/Game.tscn")
onready var ScoresScene = preload("res://src/scores/Scores.tscn")
onready var HowToPlayScene = preload("res://src/how_to_play/HowToPlay.tscn")

onready var Menu = self

onready var selections = [$NewGame, $Scores, $HowToPlay, $Quit]

const MENU_LENGTH = 4
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


func select():
	match selectedMenu:
		# New Game
		0:
			get_tree().change_scene_to(GameScene)
		# Scores
		1:
			get_tree().change_scene_to(ScoresScene)
		# How To Play?
		2:
			get_tree().change_scene_to(HowToPlayScene)
		# Quit
		3:
			get_tree().quit()

func setSelectedMenu(index):
	selectedMenu = index
	
	for i in selections.size():
		selections[i].color = COLOR_SELECTED if index == i else COLOR_UNSELECTED
		if index != 3:
			selections[3].color = COLOR_RED
#
			 
