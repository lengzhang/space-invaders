extends ParallaxBackground

export var scrolling_speed = 50

onready var texture1 = $"ParallaxLayer/TextureRect1"
onready var texture2 = $"ParallaxLayer/TextureRect2"
onready var texture3 = $"ParallaxLayer/TextureRect3"
onready var texture4 = $"ParallaxLayer/TextureRect4"
onready var texture5 = $"ParallaxLayer/TextureRect5"
onready var texture6 = $"ParallaxLayer/TextureRect6"
onready var texture7 = $"ParallaxLayer/TextureRect7"
onready var texture8 = $"ParallaxLayer/TextureRect8"
onready var texture9 = $"ParallaxLayer/TextureRect9"


func _process(delta):
	scroll_base_offset.y += scrolling_speed * delta
	if(GameManager.level == 2):
		texture2.visible = true
		texture1.visible = false
	elif(GameManager.level == 3):
		texture3.visible = true
		texture2.visible = false
	elif(GameManager.level == 4):
		texture4.visible = true
		texture3.visible = false
	elif(GameManager.level == 5):
		texture5.visible = true
		texture4.visible = false
	elif(GameManager.level == 6):
		texture6.visible = true
		texture5.visible = false
	elif(GameManager.level == 7):
		texture7.visible = true
		texture6.visible = false
	elif(GameManager.level == 8):
		texture8.visible = true
		texture7.visible = false
	elif(GameManager.level == 9):
		texture9.visible = true
		texture8.visible = false
	
