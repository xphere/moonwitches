extends Behaviour

export(NodePath) var applies_to = NodePath("..")
export(NodePath) var walk_to = NodePath(".")

var yielding : GDScriptFunctionState


func apply() -> void:
	set_process_input(true)
	var destination := (get_node(walk_to) as Node2D).global_position
	yielding = get_node(applies_to).walk_to(destination)
	yield(yielding, "completed")
	yielding = null
	set_process_input(false)


func stop() -> void:
	if yielding:
		yielding.unreference()
		yielding = null
