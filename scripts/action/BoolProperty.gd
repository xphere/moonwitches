extends Node

signal completed()

export var node : NodePath
export var property_name : String
export var value := false


func execute() -> void:
	var _node := get_node(node)
	_node.set_deferred(property_name, value)
	emit_signal("completed")
