extends Scene

signal scene_ready(scene)

onready var mentor_viewport : Viewport = $"Viewport#Mentor"
onready var mentor_camera : Camera2D = mentor_viewport.get_node("Camera")
onready var pupil_viewport : Viewport = $"Viewport#Pupil"
onready var pupil_camera : Camera2D = pupil_viewport.get_node("Camera")
onready var max_distance := 0.25 * mentor_viewport.size

var mentor : Node2D
var pupil : Node2D
var current_scene : Node
var camera_position := Vector2.ZERO


func _ready() -> void:
	set_process(false)
	var world_2d = mentor_viewport.world_2d
	pupil_viewport.world_2d = world_2d
	material.set_shader_param('pupil_view', pupil_viewport.get_texture())
	connect("load_started", self, "_on_load_started", [], CONNECT_DEFERRED)
	connect("scene_created", self, "_on_scene_created", [], CONNECT_DEFERRED)


func _on_load_started() -> void:
	Game.pause()
	set_process(false)
	mentor = null
	pupil = null
	if current_scene:
		current_scene.queue_free()


func _on_scene_created(scene: Node) -> void:
	current_scene = scene
	scene.pause_mode = Node.PAUSE_MODE_STOP
	mentor = scene.find_node("Mentor")
	pupil = scene.find_node("Pupil")
	mentor_viewport.call_deferred("add_child", scene)
	yield(scene, "ready")
	material.set_shader_param('viewport_size', mentor_viewport.size)
	Game.unpause()
	emit_signal("scene_ready", scene)
	set_process(true)


func _process(_delta: float) -> void:
	var difference := pupil.global_position - mentor.global_position
	difference.x = clamp(difference.x, -max_distance.x, max_distance.x)
	difference.y = clamp(difference.y, -max_distance.y, max_distance.y)
	mentor_camera.global_position = mentor.global_position + 0.5 * difference
	pupil_camera.global_position = pupil.global_position - 0.5 * difference
	material.set_shader_param('mentor_position', _screen_position(mentor_viewport, mentor))
	material.set_shader_param('pupil_position', _screen_position(pupil_viewport, pupil))
	material.set_shader_param('split', should_split())


func should_split() -> bool:
	var origin := mentor_viewport.canvas_transform.origin
	var destination := pupil_viewport.canvas_transform.origin

	return origin.distance_squared_to(destination) > 0.1


func _screen_position(viewport: Viewport, item: CanvasItem) -> Vector2:
	return (viewport.canvas_transform * item.get_global_transform()).origin / viewport.size
