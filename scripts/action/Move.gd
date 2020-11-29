extends Node2D

signal completed()

export var node : NodePath


func execute() -> void:
	get_node(node).global_position = global_position
	emit_signal("completed")
