extends MarginContainer

const SCORE_FILE_PATH = "user://classic-scores.cfg"

onready var ClassicGame = $"../"

onready var Level = $CenterContainer/HBoxContainer/HBoxContainer/Level/Value
onready var Score = $CenterContainer/HBoxContainer/HBoxContainer/Score/Value

var done = false
	
func _ready():
	Level.text = String(ClassicGame.level)
	Score.text = String(ClassicGame.score)

func _input(event):
	if event.is_action_pressed("confirm"):
	
		var config = ConfigFile.new()
		
		var err = config.load(SCORE_FILE_PATH)
		if err != OK:
			config = ConfigFile.new()
		
		var time = OS.get_datetime()

		var timeStr = (
			String(time.get("year"))
			+ "-" + String(time.get("month"))
			+ "-" + String(time.get("day"))
			+ " " + String(time.get("hour"))
			+ ":" + String(time.get("minute"))
			+ ":" + String(time.get("second"))
		)
		
		config.set_value("scores", timeStr, [String(ClassicGame.level), String(ClassicGame.score)])
		
		config.save(SCORE_FILE_PATH)
		get_tree().change_scene("res://src/main_menu/MainMenu.tscn")
