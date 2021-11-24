extends ParallaxBackground


export var scrolling_speed = 100

func _process(delta):
	scroll_base_offset.y += scrolling_speed * delta

