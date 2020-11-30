extends KinematicBody2D

export var speed := 32.0

onready var body := get_node(".") as KinematicBody2D
onready var ray := get_node("Ray") as RayCast2D

var chase : Node2D
var ghost := false
var distribution := 0.5


func _ready() -> void:
	Game.connect("paused", self, "_on_paused")
	Game.connect("unpaused", self, "_on_unpaused")
	var angle := randf() * TAU
	$"Sprite#1".global_position.rotated(angle)
	$"Sprite#2".global_position.rotated(angle)


func _process(_delta: float) -> void:
	var reference : Vector2 = chase.top if distribution < 0.5 else chase.bottom
	ray.cast_to = (reference - global_position).clamped(16.0)


func _physics_process(_delta: float) -> void:
	var destination := chase.at_position(distribution - 0.05 + 0.1 * randf()) as Vector2
	var direction := (destination - global_position).normalized()

	if ray.is_colliding():
		var center : Vector2 = 0.5 * (chase.bottom + chase.top)
		direction += (center - global_position).normalized()

	body.move_and_slide(direction * speed)

	if not is_on_wall() and not ghost:
		$Timer.stop()

	elif $Timer.is_stopped():
		$Timer.start()


func _on_Timer_timeout() -> void:
	if ghost:
		ghost = false
		$Collision.set_deferred("disabled", false)
	else:
		ghost = true
		$Timer.call_deferred("start")
		$Collision.set_deferred("disabled", true)


func _on_paused() -> void:
	set_process(false)
	set_physics_process(false)


func _on_unpaused() -> void:
	set_process(true)
	set_physics_process(true)


func save() -> Dictionary:
	return {
		"position": global_position,
	}


func restore(data: Dictionary) -> void:
	global_position = data["position"]
	ghost = false
	$Timer.stop()
	$Collision.set_deferred("disabled", false)
