extends AudioStreamPlayer

@export var songs: Array[AudioStream] = []
var current_index: int = 0

func _ready() -> void:
	finished.connect(_on_finished)
	play_song(0)

func play_song(index: int) -> void:
	if songs.is_empty():
		return
	current_index = index
	stream = songs[current_index]
	play()

func _on_finished() -> void:
	current_index = (current_index + 1) % songs.size()  # loops back to 0
	play_song(current_index)
