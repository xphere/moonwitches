extends Node

signal completed()

export var node : NodePath


func execute() -> void:
	get_node(node).connect("completed", self, "_on_completed")


func _on_completed() -> void:
	emit_signal("completed")
