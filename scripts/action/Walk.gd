extends Node2D

signal completed()

export(Group.Who) var who := Group.Who.Both


func execute() -> void:
	var group := get_tree().get_nodes_in_group("group").front() as Group
	yield(group.walk_to(global_position, who), "completed")
	emit_signal("completed")
