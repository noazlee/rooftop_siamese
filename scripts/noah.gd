extends Area2D

@onready var audio_stream_player_2d_2: AudioStreamPlayer2D = $AudioStreamPlayer2D2

func _on_body_entered(body: Node2D) -> void:
	print("LEVEL COMPLETE!")
	audio_stream_player_2d_2.play()
	get_tree().change_scene_to_file("res://scenes/game.tscn")
