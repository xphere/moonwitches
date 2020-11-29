extends Area2D

signal triggered()

export var expected := 1

var _amount := 0


func _on_Exit_body_entered(_body: Node) -> void:
	_set_amount(_amount + 1)


func _on_Exit_body_exited(_body: Node) -> void:
	_set_amount(_amount - 1)


func _set_amount(amount: int) -> void:
	_amount = amount
	if _amount == expected:
		emit_signal("triggered")
