extends Node

signal completed()

export(NodePath) var group : NodePath
export(bool) var together := true


func execute() -> void:
	get_node(group).set_together(together)
	emit_signal("completed")
