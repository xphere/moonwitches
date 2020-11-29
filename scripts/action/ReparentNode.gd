extends Node

signal completed()

export var node : NodePath
export var parent : NodePath
onready var _node := get_node(node)
onready var _parent := get_node(parent)


func execute() -> void:
	_node.get_parent().remove_child(_node)
	_parent.add_child(_node)
	emit_signal("completed")
