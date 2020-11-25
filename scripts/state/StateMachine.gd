extends Node
class_name StateMachine

var _state : State
var _board := {}
var _stack := []


func _ready() -> void:
	_enter_state(get_child(0) as State)


func update(delta: float) -> void:
	if _state:
		_state.update(delta, _board)


func change_to(name: String, settings: Dictionary = {}) -> void:
	var state : State = find_node(name)
	_leave_state()
	for setting_name in settings:
		_board[setting_name] = settings[setting_name]
	_enter_state(state)

	if state.has_signal("completed"):
		yield(state, "completed")


func push_state() -> void:
	_stack.push_back(_state)
	_state = null


func pop_state() -> void:
	_leave_state()
	_state = _stack.pop_back()


func _enter_state(state: State) -> void:
	_state = state
	_state.enter(_board)


func _leave_state() -> void:
	if _state:
		_state.leave()
	_state = null


func save() -> Dictionary:
	return {
		name = _state.name,
		data = _state.save(),
		board = _board,
	}


func restore(data: Dictionary) -> void:
	get_node(data["name"]).restore(data["data"])
