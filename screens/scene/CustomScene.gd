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
	Game.clear()
	if current_scene and current_scene.is_inside_tree():
		current_scene.get_parent().remove_child(current_scene)
		current_scene.queue_free()
		current_scene = null


func _on_scene_created(scene: Node) -> void:
	current_scene = scene
	scene.pause_mode = Node.PAUSE_MODE_STOP
	follow_characters()
	Game.dialog.set_talker("Gyna", mentor)
	Game.dialog.set_talker("Ann", pupil)
	mentor_viewport.call_deferred("add_child", scene)
	yield(scene, "ready")
	material.set_shader_param('viewport_size', mentor_viewport.size)
	Game.unpause()
	set_process(true)
	emit_signal("scene_ready", scene)


func follow_characters() -> void:
	mentor = current_scene.find_node("Mentor")
	pupil = current_scene.find_node("Pupil")


func follow(node: Node2D) -> void:
	mentor = node
	pupil = node
	if not node.is_connected("tree_exiting", self, "follow_characters"):
		node.connect("tree_exiting", self, "follow_characters")


func _process(_delta: float) -> void:
	_update_cameras()
	material.set_shader_param('mentor_position', _viewport_uv(mentor_viewport, mentor))
	material.set_shader_param('pupil_position', _viewport_uv(pupil_viewport, pupil))
	material.set_shader_param('split', _should_split_cameras())


func _should_split_cameras() -> bool:
	var origin := mentor_viewport.canvas_transform.origin
	var destination := pupil_viewport.canvas_transform.origin

	return origin.distance_to(destination) > 1.0


func _viewport_uv(viewport: Viewport, item: CanvasItem) -> Vector2:
	return (viewport.canvas_transform * item.get_global_transform()).origin / viewport.size


func _update_cameras() -> void:
	var difference := Vector2(
		clamp(
			pupil.global_position.x - mentor.global_position.x,
			-max_distance.x, max_distance.x
		),
		clamp(
			pupil.global_position.y - mentor.global_position.y,
			-max_distance.y, max_distance.y
		)
	)

	mentor_camera.global_position = mentor.global_position + 0.5 * difference
	pupil_camera.global_position = pupil.global_position - 0.5 * difference
