extends Behaviour


func apply() -> void:
	var destination := (get_node(".") as Node2D).global_position
	yield(applies_to().walk_to(destination), "completed")
