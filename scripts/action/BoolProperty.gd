extends Node

signal completed()

export(NodePath) var node : NodePath
export(String) var property_name : String
export(bool) var value := false


func execute() -> void:
	var _node := get_node(node)
	_node.set_deferred(property_name, value)
	emit_signal("completed")
