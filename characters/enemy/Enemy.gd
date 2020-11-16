extends KinematicBody2D
class_name Enemy

const DELTA = 1.5

export(float) var speed := 8.0
export(float) var chase_speed := 24.0
export(float) var sight_distance := 32.0
var surroundings := []


func walk_to(destination: Vector2) -> void:
	yield(
		$States.change_to("Walking", { destination = destination }),
		"completed"
	)


func wait(seconds: float) -> void:
	yield(get_tree().create_timer(seconds), "timeout")


func chase_to(player: Node2D) -> void:
	$States.push_state()
	yield(
		$States.change_to("Chasing"),
		"completed"
	)
	$States.pop_state()


func _physics_process(_delta: float) -> void:
	$States.update(_delta)


func _on_Hitbox_body_entered(body: KinematicBody2D) -> void:
	body.hit()


func _on_Vision_body_entered(body: KinematicBody2D) -> void:
	surroundings.append(body)


func _on_Vision_body_exited(body: Node) -> void:
	surroundings.erase(body)


func has_line_of_vision(destination: Vector2, max_distance: float = 32.0) -> bool:
	var position := destination - global_position
	var distance := position.length()
	if distance > max_distance:
		return false

	return _collides(position.normalized() * distance)


func move_towards(destination: Vector2, speed: float) -> void:
	var position := destination - global_position
	var velocity := position.clamped(speed)
	move_and_slide(velocity)


func respawn_at(destination: Vector2) -> void:
	$States.push_state()
	$Animation.play("Respawn")
	yield($Animation, "animation_finished")
	global_position = destination
	$Animation.play_backwards("Respawn")
	yield($Animation, "animation_finished")
	$States.pop_state()


func can_walk_straight(destination: Vector2) -> bool:
	return _collides(destination - global_position)


func _collides(destination: Vector2) -> bool:
	var ray : RayCast2D = $Vision/Ray
	ray.cast_to = destination
	ray.force_raycast_update()

	return not ray.is_colliding()


func is_near(position: Vector2) -> bool:
	return global_position.distance_squared_to(position) < DELTA


func search_target() -> Node2D:
	var closest_target
	var distance := INF

	for element in surroundings:
		var target := element as Node2D
		if not has_line_of_vision(target.global_position, sight_distance):
			continue
		var target_distance := target.global_position.distance_squared_to(global_position)
		if target_distance < distance:
			distance = target_distance
			closest_target = target

	return closest_target as Node2D
