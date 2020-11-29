extends Behaviour

export var elapsed_time := 1.0


func apply() -> void:
	yield(applies_to().wait(elapsed_time), "completed")
