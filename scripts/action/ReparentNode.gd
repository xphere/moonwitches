extends Node

signal completed()

export var node : NodePath
export var parent : NodePath
onready var _node := get_node(node)
onready var _parent := get_node(parent)


func execute() -> void:
	var current_parent := _node.get_parent()
	if current_parent != _parent:
		current_parent.remove_child(_node)
		_parent.add_child(_node)
	emit_signal("completed")
