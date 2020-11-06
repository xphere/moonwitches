extends KinematicBody2D

export(float) var max_speed := 32.0
export(NodePath) var controller

var _current_speed
var _controller


func _ready() -> void:
	_current_speed = max_speed
	if controller:
		set_controller(controller)


func _physics_process(_delta: float) -> void:
	var movement : Vector2 = _controller.get_movement()
	if not movement:
		return

	movement = move_and_slide(movement * _current_speed)


func set_speed(speed: float) -> void:
	_current_speed = speed


func set_controller(path: NodePath) -> void:
	controller = path
	_controller = get_node(controller)
