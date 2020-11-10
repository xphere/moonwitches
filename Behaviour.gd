extends Node
class_name Behaviour


func _ready() -> void:
	connect("tree_exiting", self, "stop")


func apply() -> void:
	pass


func stop() -> void:
	pass
