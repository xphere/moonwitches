extends Node

signal triggered()


# Call this method from any signal to start the trigger
func trigger() -> void:
	emit_signal("triggered")
