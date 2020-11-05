extends Node

export(NodePath) var following


func get_movement() -> Vector2:
	if not following:
		return $Controller.get_movement()

	var destination := (get_node(following) as Node2D).global_position
	var path : Vector2 = destination - get_parent().global_position

	if path.length_squared() <= 1.0:
		return Vector2.ZERO

	return path.normalized()
