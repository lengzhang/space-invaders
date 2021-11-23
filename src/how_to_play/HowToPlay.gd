extends Node2D

#Sound Effects
onready var backgroundSoundtrack = AudioStreamPlayer.new()

func _ready():
	self.add_child(backgroundSoundtrack)
	backgroundSoundtrack.stream = load("res://assets/Soundtracks/Roa - One Wish.mp3")
	backgroundSoundtrack.play()
	
func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://src/main_menu/MainMenu.tscn")
