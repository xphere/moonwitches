extends Node

signal completed()

export(NodePath) var node : NodePath
export(bool) var disable := false


func execute() -> void:
	var _node := get_node(node)
	_node.disabled = disable
	emit_signal("completed")
