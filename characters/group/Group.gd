extends Node
class_name Group

enum Who {
	Both,
	Mentor,
	Pupil,
}

const GROUP_DISTANCE := 24.0

export(bool) var is_ability_available := true
export(bool) var together := true
export(int, LAYERS_2D_PHYSICS) var mask

onready var _paused := Game.is_paused()


func _ready() -> void:
	Game.connect("paused", self, "_on_paused")
	Game.connect("unpaused", self, "_on_unpaused")
	_set_together(together)


func set_together(value: bool) -> void:
	if value == together:
		return
	_set_together(value)


func _set_together(value: bool) -> void:
	var is_paused := _paused
	if is_paused:
		_on_unpaused()
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
	if is_paused:
		_on_paused()


func _input(event) -> void:
	if event.is_action_pressed("change_group") and not _paused and _can_change_group():
		set_together(not together)


func _can_change_group() -> bool:
	if not is_ability_available:
		return false

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


func _on_paused() -> void:
	if _paused:
		return

	_paused = true
	$Mentor.push_controller($Mentor.get_path_to($Mentor/Cinematic))
	if not together:
		$Pupil.push_controller($Pupil.get_path_to($Pupil/Cinematic))


func _on_unpaused() -> void:
	if not _paused:
		return

	_paused = false
	$Mentor.pop_controller()
	if not together:
		$Pupil.pop_controller()


func walk_to(position: Vector2, who) -> void:
	var were_together := together
	set_together(who == Who.Both)

	var cinematic := $Pupil/Cinematic if who == Who.Pupil else $Mentor/Cinematic
	cinematic.call_deferred("walk_to", position)
	yield(cinematic, "completed")

	set_together(were_together)
