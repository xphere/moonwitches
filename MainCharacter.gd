extends KinematicBody2D

export(float) var speed := 32.0


func _physics_process(_delta: float) -> void:
	var movement : Vector2 = $Controller.get_movement()
	if movement:
		movement = move_and_slide(movement * _delta * speed)
