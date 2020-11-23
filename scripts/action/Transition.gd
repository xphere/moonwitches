extends Node

signal completed()

enum State { Show, Hide }

export(State) var transition := State.Show
export(NodePath) var overlay : NodePath
export(bool) var clear_overlay := true
export(float) var duration := 1.0


func execute() -> void:
	Game.transition.connect("completed", self, "_on_transition_completed")
	if transition == State.Show:
		_add_overlay()
		Game.transition.fade_in(duration)
	else:
		Game.transition.fade_out(duration)


func _on_transition_completed() -> void:
	if transition == State.Hide and clear_overlay:
		Game.transition.clear_overlay()
	emit_signal("completed")


func _add_overlay() -> void:
	if clear_overlay:
		Game.transition.clear_overlay()

	if not overlay:
		return

	var node := get_node(overlay)
	if not node:
		return

	var instance := node.duplicate()
	if instance is CanvasItem:
		instance.show()

	Game.transition.overlay(instance)
