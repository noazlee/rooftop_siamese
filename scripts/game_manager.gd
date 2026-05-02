extends Node

var score = 0
var num_cat_bosses = 0
@onready var score_label: Label = $"../Hiroshi/Camera2D/CanvasLayer/ScoreLabel"

func add_cat_boss():
	num_cat_bosses += 1
	
func get_cat_boss():
	return num_cat_bosses

func add_score():
	score += 1
	score_label.text = ":"+str(score)
