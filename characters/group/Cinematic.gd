extends Node

signal completed()


var _walking := false
var _walk_to : Vector2


func _ready() -> void:
	set_process(false)


func get_movement() -> Vector2:
	if not _walking:
		return Vector2.ZERO

	var path : Vector2 = _walk_to - get_parent().global_position
	if path.length_squared() <= 1.0:
		return Vector2.ZERO

	return path.normalized()


func walk_to(destination: Vector2) -> void:
	_walking = true
	_walk_to = destination
	set_process(true)


func _process(_delta: float) -> void:
	if _walk_to.distance_squared_to(get_parent().global_position) > 1.0:
		return

	set_process(false)
	_walking = false
	emit_signal("completed")
