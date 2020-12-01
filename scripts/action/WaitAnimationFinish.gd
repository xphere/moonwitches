extends Node

signal completed()

export var animation_path : NodePath


func execute() -> void:
	var animation := get_node(animation_path) as AnimationPlayer
	if animation.is_playing():
		animation.connect("animation_finished", self, "_on_animation_finished", [], CONNECT_ONESHOT)
	else:
		emit_signal("completed")


func _on_animation_finished(_animation: String) -> void:
	emit_signal("completed")
