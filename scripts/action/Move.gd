extends Node2D

signal completed()

export(NodePath) var node : NodePath


func execute() -> void:
	get_node(node).global_position = global_position
	emit_signal("completed")
