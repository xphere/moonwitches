extends Node

signal completed()

export var wait := false
export(float, 0.0, 1.0) var from := 0.0
export(float, 0.0, 1.0) var to := 1.0
export(float, 0.0, 10.0) var duration := 10.0
export var audio : NodePath
var tween : Tween


func execute() -> void:
	tween = Tween.new()
	owner.add_child(tween)

	tween.interpolate_method(
		self, "_set_volume",
		from, to,
		duration, Tween.TRANS_LINEAR, Tween.EASE_OUT
	)
	tween.call_deferred("start")

	if wait:
		tween.connect("tween_all_completed", self, "_on_tween_all_completed", [], CONNECT_ONESHOT)
	else:
		emit_signal("completed")


func _on_tween_all_completed() -> void:
	emit_signal("completed")
	tween.queue_free()


func _set_volume(value: float) -> void:
	get_node(audio).volume_db = linear2db(value)
