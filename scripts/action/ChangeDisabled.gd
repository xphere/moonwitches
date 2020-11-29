extends Node

signal completed()

export var node : NodePath
export var disable := false


func execute() -> void:
	var _node := get_node(node)
	_node.disabled = disable
	emit_signal("completed")
