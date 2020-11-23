extends KinematicBody2D

const SIZE := 8.0

export(float) var max_speed := 42.0
export(NodePath) var controller

var _current_speed
var _controller
var _paused := false


func _ready() -> void:
	Game.connect("paused", self, "_on_paused")
	Game.connect("unpaused", self, "_on_unpaused")
	_current_speed = max_speed
	if controller:
		set_controller(controller)


func _physics_process(_delta: float) -> void:
	if _paused:
		return

	var movement : Vector2 = _controller.get_movement()
	if movement:
		movement = move_and_slide(movement * _current_speed)


func set_speed(speed: float) -> void:
	_current_speed = speed


func set_controller(path: NodePath) -> void:
	controller = path
	_controller = get_node(controller)


func hit() -> void:
	get_tree().reload_current_scene()


func _on_paused() -> void:
	_paused = true


func _on_unpaused() -> void:
	_paused = false
