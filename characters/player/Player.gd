extends KinematicBody2D

const SIZE := 8.0

export(float) var max_speed := 42.0
export(NodePath) var controller

var _current_speed
var _controller
var _controller_stack := []


func _ready() -> void:
	_current_speed = max_speed
	if controller:
		set_controller(controller)


func _physics_process(_delta: float) -> void:
	var movement : Vector2 = _controller.get_movement()
	if movement:
		movement = move_and_slide(movement * _current_speed)


func set_speed(speed: float) -> void:
	_current_speed = speed


func set_controller(path: NodePath) -> void:
	controller = path
	_controller = get_node(controller)


func push_controller(path: NodePath) -> void:
	_controller_stack.push_back(controller)
	set_controller(path)


func pop_controller() -> void:
	if not _controller_stack.empty():
		set_controller(_controller_stack.pop_back())


func hit() -> void:
	get_tree().reload_current_scene()
