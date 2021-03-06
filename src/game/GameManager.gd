extends Node2D


# Declare variables that you want to access in another script here
# When using these variable, make sure to reset them when the game is over.
var level = 1
var numPowerUps = 0
var multiShotBonus = 2
var hasPowerUp = false

#data for laserEnemies (dont remove)
var sectionSize = 8
onready var viewportSize = get_viewport_rect().size
onready var sectionWidth = float(viewportSize[0] / sectionSize)
onready var sectionTrim = sectionWidth / 6

# Player HP
onready var max_hp = 100
onready var hp = max_hp

# Player energy
onready var max_energy = 100
onready var energy = 0
