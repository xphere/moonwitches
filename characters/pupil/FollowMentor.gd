extends Node

export var following : NodePath


func get_movement() -> Vector2:
	var _following := get_node(following) as Node2D
	if not _following:
		return Vector2.ZERO

	var destination := _following.global_position
	var path : Vector2 = destination - get_parent().global_position

	if path.length_squared() <= 1.0:
		return Vector2.ZERO

	return path.normalized()
