extends Node

const GROUP_DISTANCE := 24.0

export(bool) var together := false
export(int, LAYERS_2D_PHYSICS) var mask


func _ready() -> void:
	set_together(together)


func set_together(value: bool) -> void:
	together = value
	$Mentor.collision_mask = ($Mentor.collision_mask | mask) if value else ($Mentor.collision_mask ^ mask)
	$Mentor.set_speed(
		$Pupil.max_speed if together else $Mentor.max_speed
	)
	$Pupil.set_controller(
		$Pupil.get_path_to(
			$Pupil/Follow if together else $Pupil/Input
		)
	)


func _input(event) -> void:
	if event.is_action_pressed("change_group") and _can_change():
		set_together(not together)


func _can_change() -> bool:
	if together:
		return true

	var from : Vector2 = $Mentor.global_position
	var to : Vector2 = $Pupil.global_position
	if from.distance_to(to) > GROUP_DISTANCE:
		return false

	var _together : RayCast2D = $Together
	_together.enabled = true
	_together.global_position = from
	_together.cast_to = to - from
	_together.force_raycast_update()
	var is_colliding : bool = _together.is_colliding()
	_together.enabled = false

	return not is_colliding
