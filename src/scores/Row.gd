extends HBoxContainer

onready var Date = $Date
onready var Score = $Score

func setDate(date):
	print("date: ", date)
	Date.text = "date"
	
func setScore(score):
	Score.text = String(score)
