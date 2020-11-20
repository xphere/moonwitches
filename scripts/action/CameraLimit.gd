tool
extends Node

signal completed()


func _get_configuration_warning() -> String:
	if owner == null:
		return ""

	var first := get_child(0) as Node2D
	var second := get_child(1) as Node2D
	if not first or not second:
		return "Requires two child nodes delimiting the new camera limits"

	return ""


func execute() -> void:
	var top_left := (get_child(0) as Node2D).global_position
	var bottom_right := (get_child(1) as Node2D).global_position
	var limits := Rect2(top_left, bottom_right - top_left).abs()
	for camera in get_tree().get_nodes_in_group("camera"):
		_set_camera_limits(camera, limits)
	emit_signal("completed")


func _set_camera_limits(camera: Camera2D, limits: Rect2) -> void:
	camera.limit_left = int(limits.position.x)
	camera.limit_top = int(limits.position.y)
	camera.limit_right = int(limits.end.x)
	camera.limit_bottom = int(limits.end.y)
