extends Node2D

onready var Notice = preload("res://src/classic_game/notice/Notice.tscn")
onready var Game = preload("res://src/classic_game/game/Game.tscn")
onready var GameOver = preload("res://src/classic_game/game_over/GameOver.tscn")

onready var enemy_scores = [10, 20, 30]
onready var level = 1
onready var score = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	add_child(Notice.instance())

func start_game():
	var game = Game.instance()
	add_child(game)
	
func add_score(type):
	score += enemy_scores[type]
	return score

func next_level():
	level += 1
	for i in range(0, enemy_scores.size()):
		enemy_scores[i] = enemy_scores[i] / (level - 1) * level
	var notice = Notice.instance()
	add_child(notice)

func game_over():
	add_child(GameOver.instance())
