extends KinematicBody2D
class_name Enemy

const DELTA = 1.5

export var speed := 16.0
export var chase_speed := 24.0
export var sight_distance := 32.0
export var smoothness := 1.0
var surroundings := []
var velocity := Vector2.ZERO


func _ready() -> void:
	Game.connect("paused", self, "_on_paused")
	Game.connect("unpaused", self, "_on_unpaused")


func walk_to(destination: Vector2) -> void:
	yield(
		$States.change_to("Walking", { destination = destination }),
		"completed"
	)


func wait(seconds: float) -> void:
	yield(get_tree().create_timer(seconds), "timeout")


func chase() -> void:
	$States.push_state()
	yield(
		$States.change_to("Chasing", { chase_from = global_position }),
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


func _on_paused() -> void:
	set_process(false)
	set_physics_process(false)


func _on_unpaused() -> void:
	set_process(true)
	set_physics_process(true)


func has_line_of_vision(destination: Vector2) -> bool:
	var position := destination - global_position
	var distance := position.length()

	if distance > sight_distance:
		return false

	return not _collides($Vision/Ray, position.normalized() * distance)


func walk_towards(destination: Vector2) -> void:
	var position := destination - global_position
	velocity = position.clamped(speed)
	if smoothness < 1.0:
		var forced := position.normalized() * speed
		velocity = (velocity * smoothness) + (forced * (1.0 - smoothness))

	move_and_slide(velocity)


func run_towards(destination: Vector2) -> void:
	var position := destination - global_position
	velocity = position.normalized() * chase_speed
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
	return not _collides($Hitbox/Ray, destination - global_position)


func _collides(ray: RayCast2D, destination: Vector2) -> bool:
	ray.cast_to = destination
	ray.force_raycast_update()

	return ray.is_colliding()


func is_near(position: Vector2) -> bool:
	return global_position.distance_squared_to(position) < DELTA


func search_target() -> Node2D:
	var closest_target
	var distance := INF

	for element in surroundings:
		var target := element as Node2D
		if not has_line_of_vision(target.global_position):
			continue
		var target_distance := target.global_position.distance_squared_to(global_position)
		if target_distance < distance:
			distance = target_distance
			closest_target = target

	return closest_target as Node2D
