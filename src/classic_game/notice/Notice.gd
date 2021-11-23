extends MarginContainer

onready var ClassicGame = $"../"

onready var Level = $VBoxContainer/Level/Level
onready var Score = $VBoxContainer/Score/Score
onready var Enemy1Score = $VBoxContainer/CenterContainer/ScoreAdvanceTable/Enemy1/Enemy1Score
onready var Enemy2Score = $VBoxContainer/CenterContainer/ScoreAdvanceTable/Enemy2/Enemy2Score
onready var Enemy3Score = $VBoxContainer/CenterContainer/ScoreAdvanceTable/Enemy3/Enemy3Score

# Sound Effect
onready var Classic_backgroundSoundtrack = AudioStreamPlayer.new()

func _ready():
	Level.text = String(ClassicGame.level)
	Score.text = String(ClassicGame.score)
	var enemy_scores = ClassicGame.enemy_scores
	Enemy1Score.text = String(enemy_scores[0])
	Enemy2Score.text = String(enemy_scores[1])
	Enemy3Score.text = String(enemy_scores[2])
	self.add_child(Classic_backgroundSoundtrack)
	Classic_backgroundSoundtrack.stream = load("res://assets/SoundEffect/Classic_Unused.mp3")
	Classic_backgroundSoundtrack.play()

func _input(event):
	if event.is_action_pressed("confirm"):
		queue_free()
		ClassicGame.start_game()
