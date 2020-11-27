extends Node

signal completed()

enum State { Show, Hide }

export(State) var transition := State.Show
export(NodePath) var overlay : NodePath = "Overlay"
export(bool) var clear_overlay := true
export(float) var duration := 1.0
export(Color) var color := Color.black


func execute() -> void:
	Game.transition.connect("completed", self, "_on_transition_completed", [], CONNECT_ONESHOT)
	if transition == State.Show:
		Game.transition.color = color
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

	if not overlay or not has_node(overlay):
		return

	var node := get_node(overlay)
	var instance := node.duplicate()
	if instance is CanvasItem:
		instance.show()

	Game.transition.overlay(instance)
