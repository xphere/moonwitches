extends Node

signal completed()

export(bool) var together := true


func execute() -> void:
	var group := get_tree().get_nodes_in_group("group").front() as Group
	group.set_together(together)
	emit_signal("completed")
