tool
extends Node

signal completed()

export var duration := 0.0

var _current : Node


func _ready() -> void:
	add_to_group("camera_limits")


func _get_configuration_warning() -> String:
	if owner == null:
		return ""

	var first := get_child(0) as Node2D
	var second := get_child(1) as Node2D
	if not first or not second:
		return "Requires two child nodes delimiting the new camera limits"

	return ""


func execute() -> void:
	if _current and _current == self:
		emit_signal("completed")
		return

	_set_as_current(self)

	var limits := _calculate_limits()
	if duration > 0.0:
		_animate_limits(limits)
	else:
		_set_limits(limits)
		emit_signal("completed")


func _set_as_current(node: Node) -> void:
	if _current and _current == node:
		return
	var group := "restorable"
	if _current and _current.is_in_group(group):
		_current.remove_from_group(group)
	node.add_to_group(group)
	get_tree().set_group("camera_limits", "_current", node)


func _calculate_limits() -> Rect2:
	var top_left := (get_child(0) as Node2D).global_position
	var bottom_right := (get_child(1) as Node2D).global_position

	return Rect2(top_left, bottom_right - top_left).abs()


func _set_limits(limits: Rect2) -> void:
	for camera in _get_cameras():
		_set_camera_limits(camera, limits)


func _on_tween_completed(tween: Tween) -> void:
	tween.queue_free()
	emit_signal("completed")


func _animate_limits(limits: Rect2) -> void:
	var tween := Tween.new()
	add_child(tween)
	for camera in _get_cameras():
		tween.interpolate_property(
			camera, "limit_left",
			camera.limit_left, int(limits.position.x),
			duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
		)
		tween.interpolate_property(
			camera, "limit_top",
			camera.limit_top, int(limits.position.y),
			duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
		)
		tween.interpolate_property(
			camera, "limit_right",
			camera.limit_right, int(limits.end.x),
			duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
		)
		tween.interpolate_property(
			camera, "limit_bottom",
			camera.limit_bottom, int(limits.end.y),
			duration, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT
		)
	tween.connect("tween_all_completed", self, "_on_tween_completed", [ tween ])
	tween.start()


func _set_camera_limits(camera: Camera2D, limits: Rect2) -> void:
	camera.limit_left = int(limits.position.x)
	camera.limit_top = int(limits.position.y)
	camera.limit_right = int(limits.end.x)
	camera.limit_bottom = int(limits.end.y)


func _get_cameras() -> Array:
	return get_tree().get_nodes_in_group("camera")


func save() -> Dictionary:
	return {
		"duration": duration,
	}


func restore(_data: Dictionary) -> void:
	duration = _data["duration"]
	_set_as_current(self)
	_set_limits(_calculate_limits())
