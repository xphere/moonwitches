extends Node

signal completed()

export(float) var duration := 1.0


func execute() -> void:
	get_tree().create_timer(duration).connect("timeout", self, "_on_timer_timeout")


func _on_timer_timeout() -> void:
	emit_signal("completed")
