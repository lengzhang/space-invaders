extends TextureButton

onready var game = get_node("/root").get_child(0)

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
#	print(game)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

#func _process(delta):
#	if Input.is_action_just_pressed("ui_cancel"):	
#		pause()
	
func _pressed():
	if game.has_method("pause"):
		game.pause()
