extends PathFollow2D
class_name Wave

export var speed := 32.0

onready var chasers := $Chasers as Node

var top : Vector2
var bottom : Vector2
var _needs_distribute := false
var _was_restored := false


func _ready() -> void:
	Game.connect("paused", self, "_on_paused")
	Game.connect("unpaused", self, "_on_unpaused")
	Game.connect("restored", self, "_on_restored")


func _on_Hitbox_body_entered(body: KinematicBody2D) -> void:
	var ray := $Hitbox/Ray as RayCast2D
	ray.cast_to = to_local(body.global_position)
	ray.force_raycast_update()
	if not ray.is_colliding():
		body.hit()


func at_position(_position: float) -> Vector2:
	return top + _position * (bottom - top)


func add_chaser(chaser: Node2D) -> void:
	chasers.add_child(chaser)
	chaser.chase = self
	chaser.global_position = global_position
	_needs_distribute = true


func _physics_process(delta: float) -> void:
	if _needs_distribute:
		_distribute_chasers()

	offset += delta * speed
	if self.unit_offset >= 1.0:
		queue_free()

	top = _farthest_point($Top)
	bottom = _farthest_point($Bottom)


func _farthest_point(ray: RayCast2D) -> Vector2:
	return ray.get_collision_point() if ray.is_colliding() \
	  else ray.to_global(ray.cast_to)


func _distribute_chasers() -> void:
	_needs_distribute = false
	var index := 1
	var total := chasers.get_child_count() + 2
	for child in chasers.get_children():
		var chaser := child as Node2D
		chaser.distribution = index / float(total)
		index += 1


func _on_paused() -> void:
	set_physics_process(false)


func _on_unpaused() -> void:
	set_physics_process(true)


func save() -> Dictionary:
	return {
		"offset": offset,
	}


func restore(data: Dictionary) -> void:
	_was_restored = true
	offset = data["offset"]


func _on_restored() -> void:
	if not _was_restored:
		queue_free()
	_was_restored = false


func unpause() -> void:
	for chaser in chasers.get_children():
		chaser.unpause()
	_on_unpaused()


func pause() -> void:
	for chaser in chasers.get_children():
		if chaser.has_method("paused"):
			chaser.paused()
	_on_paused()

