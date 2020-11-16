extends State

signal completed()
onready var timer : Timer = $Timer


func update(_delta: float, _board: Dictionary) -> void:
	var enemy := owner as Enemy
	var target := enemy.search_target()

	if target:
		timer.stop()
		enemy.move_towards(target.global_position, enemy.chase_speed)
	elif timer.is_stopped():
		timer.start()


func _on_Timer_timeout() -> void:
	emit_signal("completed")
