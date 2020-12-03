extends ColorRect
class_name Transition

signal completed()

onready var animation := $AnimationPlayer as AnimationPlayer


func _ready() -> void:
	animation.connect("animation_finished", self, "_on_animation_finished")


func clear_overlay() -> void:
	for child in $Overlay.get_children():
		child.queue_free()


func overlay(node: Node) -> void:
	$Overlay.add_child(node)


func fade_in(duration: float) -> void:
	animation.stop()
	_set_duration(duration)
	animation.call_deferred("play", "show")


func fade_out(duration: float) -> void:
	animation.stop()
	_set_duration(duration)
	animation.call_deferred("play", "hide")


func _on_animation_finished(_name: String) -> void:
	visible = _name == "show"
	emit_signal("completed")


func _set_duration(duration: float) -> void:
	(animation as AnimationPlayer).playback_speed = 1.0 / duration
