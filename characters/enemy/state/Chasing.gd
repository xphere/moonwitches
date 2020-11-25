extends State

signal completed()

onready var timer : Timer = $Timer
var chase_from : Vector2
var chasing : bool = false


func _ready() -> void:
	Game.connect("restored", self, "_on_restored")


func enter(board: Dictionary) -> void:
	chase_from = board["chase_from"]
	chasing = true


func leave() -> void:
	chasing = false


func update(_delta: float, _board: Dictionary) -> void:
	var enemy := owner as Enemy
	var target := enemy.search_target()

	if target:
		timer.stop()
		enemy.run_towards(target.global_position)

	elif timer.is_stopped():
		timer.start()


func _on_Timer_timeout() -> void:
	emit_signal("completed")


func save() -> Dictionary:
	return {
		chase_from = chase_from,
	}


func restore(data: Dictionary) -> void:
	chase_from = data["chase_from"]


func _on_restored() -> void:
	if not chasing:
		return

	var enemy := owner as Enemy
	enemy.global_position = chase_from

	emit_signal("completed")
