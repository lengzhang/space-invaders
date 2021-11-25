extends VBoxContainer

const COLOR_UNSELECTED = Color("808080")
const COLOR_SELECTED = Color("64a500")
const COLOR_RED = Color("ff4444")

onready var GameScene = preload("res://src/game/Game.tscn")
onready var ClassicGame = preload("res://src/classic_game/ClassicGame.tscn")
onready var ScoresScene = preload("res://src/scores/Scores.tscn")
onready var ClassicScoresScene = preload("res://src/classic-scores/Scores.tscn")
onready var Credit = preload("res://src/Credit/Credit.tscn")
onready var HowToPlayScene = preload("res://src/how_to_play/HowToPlay.tscn")

# Sound Effect
onready var soundEffect = AudioStreamPlayer.new()

onready var counter = 0

onready var Menu = self

onready var selections = [$NewGame, $ClassicGame, $Scores, $ClassicScores, $HowToPlay, $Credit, $Quit]

onready var menu_length = selections.size()
var selectedMenu = 0

func _ready():
	self.add_child(soundEffect)
	soundEffect.stream = load("res://assets/SoundEffect/select7.wav")
	setSelectedMenu(0)

func _input(event):
	if Input.is_action_just_pressed("ui_up"):
		setSelectedMenu(menu_length - 1 if selectedMenu == 0 else selectedMenu - 1)
	elif Input.is_action_just_pressed("ui_down"):
		setSelectedMenu(0 if selectedMenu == menu_length - 1 else selectedMenu + 1)
	elif Input.is_action_just_pressed("ui_accept"):
		select()

func select():
	match selectedMenu:
		0:
			# New Game
			get_tree().change_scene_to(GameScene)
		1:
			# Classic Game
			get_tree().change_scene_to(ClassicGame)
		2:
			# Scores
			get_tree().change_scene_to(ScoresScene)
		3:
			# Scores
			get_tree().change_scene_to(ClassicScoresScene)
		4:
			# How To Play
			get_tree().change_scene_to(HowToPlayScene)
		5:
			# Credit
			get_tree().change_scene_to(Credit)
		6:
			# Quit
			get_tree().quit()

func setSelectedMenu(index):
	selectedMenu = index
	for i in selections.size():
		
		if counter >= 7:
			soundEffect.play()
			
		counter = counter + 1

		selections[i].color = COLOR_SELECTED if index == i else COLOR_UNSELECTED
		
		if index != menu_length - 1:
			selections[menu_length - 1].color = COLOR_RED

