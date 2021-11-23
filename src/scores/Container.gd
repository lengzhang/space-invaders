extends ScrollContainer

onready var Container = $"."
onready var VScrollBar = Container.get_v_scrollbar()
onready var Table = $Table
onready var Row = preload("res://src/scores/Row.tscn")

var scoreFilePath = "user://scores.cfg"

#Sound Effects
onready var backgroundSoundtrack = AudioStreamPlayer.new()


func _ready():
	
	self.add_child(backgroundSoundtrack)
	backgroundSoundtrack.stream = load("res://assets/Soundtracks/Roa - One Wish.mp3")
	backgroundSoundtrack.play()

	var config = ConfigFile.new()
	
	var err = config.load(scoreFilePath)
	if err == OK:
		for section in config.get_sections():
			var datetimes = config.get_section_keys(section)
			for datetime in datetimes:
				var score = config.get_value(section, datetime)
				
				var row = Row.instance()
				row.get_child(0).text = datetime
				row.get_child(1).text = score
				Table.call_deferred("add_child", row)

	Container.scroll_horizontal_enabled = false
	Container.scroll_vertical_enabled = true


func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://src/main_menu/MainMenu.tscn")
	elif Input.is_action_pressed("ui_up"):
		VScrollBar.value -= 10
		VScrollBar.value = max(VScrollBar.value, 0)
	elif Input.is_action_pressed("ui_down"):
		VScrollBar.value += 10
		VScrollBar.value = min(VScrollBar.value, VScrollBar.max_value)
