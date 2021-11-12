extends Node2D

func _input(event):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().change_scene("res://src/main_menu/MainMenu.tscn")
