extends VBoxContainer

const COLOR_UNSELECTED = Color("808080")
const COLOR_SELECTED = Color("64a500")
const COLOR_RED = Color("ff4444")

onready var GameScene = preload("res://src/game/Game.tscn")
onready var ScoresScene = preload("res://src/scores/Scores.tscn")
onready var Credit = preload("res://src/Credit/Credit.tscn")
onready var HowToPlayScene = preload("res://src/how_to_play/HowToPlay.tscn")
onready var player = AudioStreamPlayer.new()

onready var counter = 0



onready var Menu = self

onready var selections = [$NewGame, $Scores, $HowToPlay, $Credit, $Quit]

const MENU_LENGTH = 5
var selectedMenu = 0

func _ready():
	self.add_child(player)
	player.stream = load("res://assets/SoundEffect/select7.wav")
	setSelectedMenu(0)
	
	

		
func _input(event):
	if Input.is_action_just_pressed("ui_up"):
		setSelectedMenu(MENU_LENGTH - 1 if selectedMenu == 0 else selectedMenu - 1)
	elif Input.is_action_just_pressed("ui_down"):
		setSelectedMenu(0 if selectedMenu == MENU_LENGTH - 1 else selectedMenu + 1)
	elif Input.is_action_just_pressed("ui_accept"):
		select()


func select():
	match selectedMenu:
		0:
			# New Game
			get_tree().change_scene_to(GameScene)
		1:
			# Scores
			get_tree().change_scene_to(ScoresScene)
		2:
			# How To Play
			get_tree().change_scene_to(HowToPlayScene)
		3:
			# Credit
			get_tree().change_scene_to(Credit)
		4:
			# Quit
			get_tree().quit()

func setSelectedMenu(index):
	selectedMenu = index
	for i in selections.size():
		
		if counter >= 6:
			player.play()
			
		counter = counter + 1
		
		selections[i].color = COLOR_SELECTED if index == i else COLOR_UNSELECTED
		
		if index != 4:
			selections[4].color = COLOR_RED

