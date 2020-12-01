extends Node2D

signal completed()

export var wave : PackedScene
export var chaser : PackedScene
export var speed := 31.0
export var min_chasers := 3
export var max_chasers := 6
export var waves := 16
export var elapsed := 4.0

var pending := 0
var running := 0

onready var timer := Timer.new()


func _ready() -> void:
	Game.connect("paused", self, "_on_paused")
	Game.connect("unpaused", self, "_on_unpaused")
	set_process(false)
	add_to_group("restorable")
	timer.one_shot = true
	timer.connect("timeout", self, "_on_timeout")
	add_child(timer)


func create() -> void:
	pending += waves
	if Game.is_paused():
		yield(Game, "unpaused")
	call_deferred("set_process", true)


func _process(_delta: float) -> void:
	set_process(false)
	if pending == 0:
		return

	var _chasers := min_chasers + randi() % (max_chasers - min_chasers)
	_create_wave(_chasers)
	pending -= 1
	if pending > 0:
		_start_timer()


func _start_timer() -> void:
	timer.start(
		elapsed / waves
	)


func _on_timeout() -> void:
	set_process(true)


func _create_wave(_chasers: int) -> void:
	var _wave := wave.instance() as Wave
	_wave.speed = speed
	running += 1
	_wave.connect("tree_exited", self, "_on_wave_completed")
	add_child(_wave)

	for _index in range(0, _chasers):
		var _chaser := chaser.instance()
		_wave.add_chaser(_chaser)
		_chaser.speed = speed + 1


func save() -> Dictionary:
	return {
		pending = pending,
	}


func restore(data: Dictionary) -> void:
	timer.stop()
	pending = data["pending"]
	set_process(false)
	call_deferred("set_process", true)


func _on_paused() -> void:
	timer.paused = true


func _on_unpaused() -> void:
	timer.paused = false


func _on_wave_completed() -> void:
	running -= 1
	if running == 0:
		emit_signal("completed")


func unpause() -> void:
	for child in get_children():
		if child.has_method("unpause"):
			child.unpause()
	_on_unpaused()


func pause() -> void:
	for child in get_children():
		if child.has_method("pause"):
			child.pause()
	_on_paused()
