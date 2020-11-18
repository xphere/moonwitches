extends Scene

onready var mentor_viewport := $"Viewport#Mentor"
onready var mentor_camera := mentor_viewport.get_node("Camera")
onready var pupil_viewport := $"Viewport#Pupil"
onready var pupil_camera := pupil_viewport.get_node("Camera")

var mentor : Node2D
var pupil : Node2D
var current_scene : Node


func _ready() -> void:
	set_process(false)
	var world_2d = mentor_viewport.world_2d
	pupil_viewport.world_2d = world_2d
	material.set_shader_param('pupil_view', pupil_viewport.get_texture())
	connect("load_started", self, "_on_load_started")
	connect("scene_created", self, "_on_scene_created")


func _on_load_started() -> void:
	Game.pause()
	set_process(false)
	mentor = null
	pupil = null
	if current_scene:
		current_scene.queue_free()


func _on_scene_created(scene: Node) -> void:
	current_scene = scene
	mentor_viewport.add_child(scene)

	mentor = scene.find_node("Mentor")
	pupil = scene.find_node("Pupil")

	set_camera_limits(scene.get_map_limits())

	set_process(true)
	Game.unpause()


func _process(_delta: float) -> void:
	var mentor_position := mentor.global_position
	var pupil_position := pupil.global_position

	var split_distance := min(mentor_viewport.size.x, mentor_viewport.size.y) / 3.0
	var difference := pupil_position - mentor_position

	var clamped_difference := difference.clamped(split_distance)
	mentor_camera.position = mentor_position + 0.5 * clamped_difference
	pupil_camera.position = pupil_position - 0.5 * clamped_difference

	var should_split := difference.length() > split_distance
	material.set_shader_param('split', should_split)
	if should_split:
		material.set_shader_param('mentor_position', _screen_position(mentor_viewport, mentor))
		material.set_shader_param('pupil_position', _screen_position(pupil_viewport, pupil))
		material.set_shader_param('viewport_size', mentor_viewport.size)


func set_camera_limits(rect: Rect2) -> void:
	_set_camera_limits(mentor_camera, rect)
	_set_camera_limits(pupil_camera, rect)


func _set_camera_limits(camera: Camera2D, rect: Rect2) -> void:
	camera.limit_left = int(rect.position.x)
	camera.limit_right = int(rect.end.x)
	camera.limit_top = int(rect.position.y)
	camera.limit_bottom = int(rect.end.y)


func _screen_position(viewport: Viewport, item: CanvasItem) -> Vector2:
	return (viewport.canvas_transform * item.get_global_transform()).origin / viewport.size
