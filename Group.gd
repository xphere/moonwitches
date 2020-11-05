extends Node

export(bool) var together := false


func _ready() -> void:
	set_together(together)


func set_together(value: bool) -> void:
	together = value
	$Mentor.set_speed(
		$Pupil.max_speed if together else $Mentor.max_speed
	)
	$Pupil.set_controller(
		$Pupil.get_path_to(
			$Pupil/Follow if together else $Pupil/Input
		)
	)


func _input(event) -> void:
	if event.is_action_pressed("change_group"):
		set_together(not together)
