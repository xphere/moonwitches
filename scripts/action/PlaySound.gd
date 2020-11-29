extends Node

signal completed()

export var wait := false
export var audio_path : NodePath


func execute() -> void:
	var player := get_node(audio_path) as AudioStreamPlayer

	player.call_deferred("play")
	if wait:
		player.connect("finished", self, "_on_play_finished", [], CONNECT_ONESHOT)
	else:
		emit_signal("completed")


func _on_play_finished() -> void:
	emit_signal("completed")
