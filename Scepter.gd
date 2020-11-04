extends Node2D

const DISTANCE := 18.0

var _time := 0.0
var _can_be_passed := true
var _near = null


func _process(delta: float) -> void:
	_time += delta
	position = Vector2(1.0, 0.0).rotated(_time * PI) * 8.0
	if _near:
		update()
		_near = _get_protagonist_in_reach()


func _draw() -> void:
	if _near:
		draw_line(
			-position,
			_near.global_position - global_position,
			Color.white
		)


func _input(event: InputEvent) -> void:
	if not event.is_action_pressed("pass_scepter"):
		return

	if not _can_be_passed:
		return

	_near = _get_protagonist_in_reach()


func _get_protagonist_in_reach() -> KinematicBody2D:
	var parent : KinematicBody2D = get_parent()
	var protagonists := get_tree().get_nodes_in_group("protagonist")

	for protagonist in protagonists:
		if protagonist != parent and _can_reach(parent, protagonist):
			return protagonist

	return null


func _can_reach(from: KinematicBody2D, to: Node2D) -> bool:
	if from.global_position.distance_to(to.global_position) > DISTANCE:
		return false

#	return not from.test_move(from.transform, (to.global_position - from.global_position))
	return true
