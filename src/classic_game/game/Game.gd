extends Node2D

onready var Parent = $"../"
onready var Life = $Life
onready var Score = $Score

onready var PLANE = preload("res://src/classic_game/plane/Plane.tscn")
onready var WAVE = preload("res://src/classic_game/wave/Wave.tscn")

onready var viewport_size = get_viewport_rect().size

onready var level = Parent.level
onready var life = 3

# Sound Effect
onready var Classic_backgroundSoundtrack = AudioStreamPlayer.new()
onready var Classic_levelClear = AudioStreamPlayer.new()
onready var Classic_gameOver = AudioStreamPlayer.new()


func _ready():
	update_info()
	var wave = WAVE.instance()
	add_child(wave)
	new_plane()
	self.add_child(Classic_backgroundSoundtrack)
	Classic_backgroundSoundtrack.stream = load("res://assets/SoundEffect/Classic_Saturn.mp3")
	self.add_child(Classic_levelClear)
	Classic_levelClear.stream = load("res://assets/SoundEffect/Classic_Level Clear.mp3")
	self.add_child(Classic_gameOver)
	Classic_gameOver.stream = load("res://assets/SoundEffect/Classic_Game Over.mp3")
	Classic_backgroundSoundtrack.play()

func add_score(type):
	Parent.add_score(type)
	update_info()
	
func next_level():
	Classic_backgroundSoundtrack.stop()
	yield(get_tree().create_timer(1), "timeout")
	Classic_levelClear.play()
	yield(get_tree().create_timer(3), "timeout")
	Parent.next_level()
	queue_free()

func plane_dead():
	if life > 0:
		life -= 1
		update_info()
		new_plane()
	else:
		game_over()

func new_plane():
	var plane = PLANE.instance()
	plane.position = Vector2(viewport_size[0] / 2, viewport_size[1] - 16)
	add_child(plane)

func update_info():
	Life.text = String(life)
	Score.text = String(Parent.score)

func game_over():
	Classic_backgroundSoundtrack.stop()
	yield(get_tree().create_timer(1), "timeout")
	Classic_gameOver.play()
	yield(get_tree().create_timer(9), "timeout")
	Parent.game_over()
	queue_free()

func _on_EndArea_area_entered(area):
	var parent = area.get_parent()
	if parent.is_in_group("enemies"):
		game_over()
