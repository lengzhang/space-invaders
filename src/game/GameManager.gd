extends Node2D


# Declare variables that you want to access in another script here
# When using these variable, make sure to reset them when the game is over.
var level = 1
var numPowerUps = 0

#data for laserEnemies (dont remove)
var sectionSize = 8
onready var viewportSize = get_viewport_rect().size
onready var sectionWidth = float(viewportSize[0] / sectionSize)
onready var sectionTrim = sectionWidth / 6
