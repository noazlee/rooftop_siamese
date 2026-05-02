extends Area2D

@onready var game_manager: Node = %GameManager

const CAT_BOSS = preload("uid://dc8ioqw4hfvqq")

func _on_body_entered(body: Node2D) -> void:
	print("cat through - spawn!")
	if game_manager.get_cat_boss() == 0:
		game_manager.add_cat_boss()
		spawn_catboss()
		
	
func spawn_catboss():
	var catboss = CAT_BOSS.instantiate()
	catboss.position = Vector2(3456, 64)
	catboss.direction = -1
	get_tree().root.add_child(catboss)
