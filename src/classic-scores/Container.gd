extends ScrollContainer

const SCORE_FILE_PATH = "user://classic-scores.cfg"

onready var Container = $"."
onready var VScrollBar = Container.get_v_scrollbar()
onready var Table = $Table
onready var Row = preload("res://src/classic-scores/Row.tscn")


func _ready():
	
	var config = ConfigFile.new()
	
	var err = config.load(SCORE_FILE_PATH)
	if err == OK:
		for section in config.get_sections():
			var datetimes = config.get_section_keys(section)
			for datetime in datetimes:
				var item = config.get_value(section, datetime)
				var level = item[0]
				var score = item[1]
				var row = Row.instance()
				row.get_child(0).text = datetime.replace(" ", "\n")
				row.get_child(1).text = level
				row.get_child(2).text = score
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
