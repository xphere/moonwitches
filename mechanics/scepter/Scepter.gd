extends Node2D

const REACH_DISTANCE := 18.0

export(bool) var can_be_passed := true
export(bool) var can_be_activated := true

onready var _throw := $Throw

var _time := 0.0
var _activated := false
var _cooldown := false


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
	if can_be_activated and not _activated and not _cooldown:
		_toggle_aura(true)
		$Duration.start()


func _on_Duration_timeout() -> void:
	_toggle_aura(false)
	_cooldown = true
	$Cooldown.start()


func _on_Cooldown_timeout() -> void:
	_cooldown = false


func _toggle_aura(value: bool) -> void:
	_activated = value
	$Aura.visible = _activated
	$Aura/Protection.set_deferred("disabled", not _activated)


func save() -> Dictionary:
	return {
		"can_be_passed": can_be_passed,
		"can_be_activated": can_be_activated,
		"parent": get_parent(),
	}


func restore(data: Dictionary) -> void:
	$Duration.stop()
	$Cooldown.stop()
	_toggle_aura(false)
	_cooldown = false

	can_be_passed = data["can_be_passed"]
	can_be_activated = data["can_be_activated"]

	var _parent := data["parent"] as Node
	if _parent != get_parent():
		get_parent().remove_child(self)
		_parent.add_child(self)
