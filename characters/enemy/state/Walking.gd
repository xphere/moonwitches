extends State

signal completed()

var destination : Vector2

func enter(board: Dictionary) -> void:
	destination = board["destination"] if board.has("destination") else owner.global_position


func update(delta: float, board: Dictionary) -> void:
	var enemy := owner as Enemy

	var target := enemy.search_target()
	if target:
		enemy.chase_to(target)
		return

	if enemy.is_near(destination):
		emit_signal("completed")

	elif enemy.can_walk_straight(destination):
		enemy.move_towards(destination, enemy.speed)

	else:
		enemy.respawn_at(destination)
