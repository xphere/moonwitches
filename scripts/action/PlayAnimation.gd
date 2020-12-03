extends Node

signal completed()

export var wait := false
export var animation_path : NodePath
export var track_name : String


func execute() -> void:
	var animation := get_node(animation_path) as AnimationPlayer

	animation.stop()
	animation.play(track_name)
	if wait:
		animation.connect("finished", self, "_on_animation_finished")
	else:
		emit_signal("completed")


func _on_animation_finished() -> void:
	emit_signal("completed")
