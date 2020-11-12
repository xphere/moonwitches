extends Node
class_name Behaviour


func _ready() -> void:
	connect("tree_exiting", self, "stop")


func apply() -> void:
	pass


func stop() -> void:
	pass


func applies_to() -> Node:
	var parent := get_parent()
	return parent.applies_to() if parent as Behaviour else parent
