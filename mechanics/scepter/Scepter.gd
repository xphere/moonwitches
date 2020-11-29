extends Node2D

const REACH_DISTANCE := 18.0

export var can_be_passed := true
export var can_be_activated := true

onready var _throw := $Throw

var _time := 0.0
var _activated := false
var _cooldown := false


func _ready() -> void:
	_toggle_aura(false)
	Game.connect("paused", self, "_on_pause")
	Game.connect("unpaused", self, "_on_unpause")


func _process(delta: float) -> void:
	_time += delta
	$Sprite.position = Vector2(1.0, 0.0).rotated(_time * PI) * 8.0
	var _progress := 0.0
	if _activated:
		_progress = 1.0 - ($Duration.time_left / $Duration.wait_time)
	elif _cooldown:
		_progress = $Cooldown.time_left / $Cooldown.wait_time
	$Usage.material.set_shader_param('progress', _progress)


func _on_pause() -> void:
	if not $Duration.is_stopped():
		$Duration.paused = true
	if not $Cooldown.is_stopped():
		$Cooldown.paused = true


func _on_unpause() -> void:
	if $Duration.is_paused():
		$Duration.paused = false
	if $Cooldown.is_paused():
		$Cooldown.paused = false


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
	$Sprite/Aura.visible = _activated
	$Aura/Protection.set_deferred("disabled", not _activated)


func save() -> Dictionary:
	return {
		"can_be_passed": can_be_passed,
		"can_be_activated": can_be_activated,
		"parent": get_parent(),
	}


func restore(data: Dictionary) -> void:
	$Duration.stop()
	$Duration.paused = false
	$Cooldown.stop()
	$Cooldown.paused = false
	_toggle_aura(false)
	_cooldown = false

	can_be_passed = data["can_be_passed"]
	can_be_activated = data["can_be_activated"]

	var _parent := data["parent"] as Node
	if _parent != get_parent():
		get_parent().remove_child(self)
		_parent.add_child(self)
