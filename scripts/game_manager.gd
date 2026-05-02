extends Node

var score = 0
@onready var score_label: Label = $"../Hiroshi/Camera2D/CanvasLayer/ScoreLabel"

func add_score():
	score += 1
	score_label.text = ":"+str(score)
