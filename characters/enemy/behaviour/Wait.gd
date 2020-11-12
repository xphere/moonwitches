extends Behaviour

export(float) var elapsed_time := 1.0


func apply() -> void:
	yield(get_tree().create_timer(elapsed_time), "timeout")
