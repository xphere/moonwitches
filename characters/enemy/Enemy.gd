extends KinematicBody2D

const DELTA = 2.0


export(float) var speed := 8.0


func walk_to(location: Vector2) -> void:
	while true:
		yield(get_tree(), "idle_frame")
		if global_position.distance_squared_to(location) < DELTA:
			break
		move_and_slide((location - global_position).normalized() * speed)


func _on_Hitbox_body_entered(body: Node) -> void:
	body.hit()
