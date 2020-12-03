extends Node
class_name Group

enum Who {
	Both,
	Mentor,
	Pupil,
}

const GROUP_DISTANCE := 24.0

export var is_ability_available := true
export var together := true
export(int, LAYERS_2D_PHYSICS) var wall_mask

onready var death_sound := $"Death Sound" as AudioStreamPlayer


func _ready() -> void:
	set_together(together)
	Game.connect("paused", self, "_on_paused")
	Game.connect("unpaused", self, "_on_unpaused")
	$Mentor.connect("hit", self, "_on_player_hit")
	$Pupil.connect("hit", self, "_on_player_hit")


func set_together(value: bool) -> void:
	together = value
	if Game.is_paused():
		_as_cinematic(together)
	else:
		_set_together(together)


func _set_together(value: bool) -> void:
	together = value

	$Mentor.set_controller($Mentor.get_path_to($Mentor/Input))
	$Mentor.collision_mask = ($Mentor.collision_mask | wall_mask) if together \
						else ($Mentor.collision_mask & ~wall_mask)

	var mentor_max_speed : float = $Pupil.max_speed - 1 if together else $Mentor.max_speed
	$Mentor.set_speed(mentor_max_speed)

	var pupil_controller := $Pupil/Follow if together else $Pupil/Input
	$Pupil.set_controller($Pupil.get_path_to(pupil_controller))


func _input(event) -> void:
	if event.is_action_pressed("change_group") and _can_change_group():
		_set_together(not together)


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
	set_process_input(false)
	_as_cinematic(together)


func _on_unpaused() -> void:
	set_process_input(true)
	_set_together(together)


func _on_player_hit() -> void:
	death_sound.play()
	Game.pause()
	Game.transition.color = Color("f3a9a4")
	Game.transition.fade_in(0.1)
	yield(Game.transition, "completed")
	Game.restore()
	Game.transition.fade_out(1.0)
	yield(Game.transition, "completed")
	Game.unpause()


func _as_cinematic(value: bool) -> void:
	$Mentor.set_controller($Mentor.get_path_to($Mentor/Cinematic))
	$Pupil.set_controller($Pupil.get_path_to($Pupil/Follow if value else $Pupil/Cinematic))


func walk_to(position: Vector2, who) -> void:
	var walk_together : bool = who == Who.Both
	_as_cinematic(walk_together)
	var cinematic := $Pupil/Cinematic if who == Who.Pupil else $Mentor/Cinematic
	cinematic.call_deferred("walk_to", position)
	yield(cinematic, "completed")
	_as_cinematic(together)


func save() -> Dictionary:
	return {
		"mentor": $Mentor.global_position,
		"follower": $Mentor/Follower.global_position,
		"pupil": $Pupil.global_position,
		"available": is_ability_available,
		"together": together,
	}


func restore(data: Dictionary) -> void:
	$Mentor.global_position = data["mentor"]
	$Mentor/Follower.global_position = data["follower"]
	$Pupil.global_position = data["pupil"]
	is_ability_available = data["available"]
	together = data["together"]
