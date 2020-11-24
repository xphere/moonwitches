extends Node2D

signal completed()

export(NodePath) var group_path : NodePath
export(Group.Who) var who := Group.Who.Both


func execute() -> void:
	yield(
		get_node(group_path).walk_to(global_position, who),
		"completed"
	)
	emit_signal("completed")
