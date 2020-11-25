extends Node2D

const REACH_DISTANCE := 18.0
const DURATION_TIME := 5.0
const COOLDOWN_TIME := 10.0

export(bool) var can_be_passed := true
export(bool) var can_be_activated := true

var _time := 0.0
var _activated := false
var _cooldown := false
onready var _throw := $Throw


func _ready() -> void:
	_toggle_aura(false)


func _process(delta: float) -> void:
	_time += delta
	$Sprite.position = Vector2(1.0, 0.0).rotated(_time * PI) * 8.0


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pass_scepter"):
		_pass_scepter()

	elif event.is_action_pressed("activate_scepter"):
		_activate_scepter()


func _pass_scepter() -> void:
	if not can_be_passed:
		return

	var _new_owner = _get_protagonist_in_reach()
	if _new_owner:
		get_parent().remove_child(self)
		_new_owner.add_child(self)


func _get_protagonist_in_reach() -> KinematicBody2D:
	var parent : KinematicBody2D = get_parent()
	var protagonists := get_tree().get_nodes_in_group("protagonist")

	for protagonist in protagonists:
		if protagonist != parent and _can_reach(parent, protagonist):
			return protagonist

	return null


func _can_reach(from: KinematicBody2D, to: Node2D) -> bool:
	if from.global_position.distance_to(to.global_position) > REACH_DISTANCE:
		return false

	if not _can_throw(from.global_position, to.global_position):
		return false

	return true


func _can_throw(from: Vector2, to: Vector2) -> bool:
	_throw.enabled = true
	_throw.global_position = from
	_throw.cast_to = to - from
	_throw.force_raycast_update()
	var is_colliding : bool = _throw.is_colliding()
	_throw.enabled = false

	return not is_colliding


func _activate_scepter() -> void:
	if not can_be_activated or _activated or _cooldown:
		return

	_activated = true
	_toggle_aura(_activated)
	yield(get_tree().create_timer(DURATION_TIME), "timeout")
	_activated = false

	_cooldown = true
	_toggle_aura(_activated)
	yield(get_tree().create_timer(COOLDOWN_TIME), "timeout")
	_cooldown = false


func _toggle_aura(active: bool) -> void:
	$Aura.visible = active
	$Aura/Protection.set_deferred("disabled", not active)
