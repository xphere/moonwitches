extends Node2D

export var wave : PackedScene
export var chaser : PackedScene
export var speed := 32.0
export var min_chasers := 3
export var max_chasers := 5
export var waves := 16
export var elapsed := 4.0

var pending := 0

onready var timer := Timer.new()


func _ready() -> void:
	timer.one_shot = true
	timer.connect("timeout", self, "_on_timeout")
	add_child(timer)


func create() -> void:
	pending += waves
	_start_timer()


func _start_timer() -> void:
	timer.start(
		randf() - 0.5 + elapsed / waves
	)


func _on_timeout() -> void:
	var _chasers := min_chasers + randi() % (max_chasers - min_chasers)
	_create_wave(_chasers)
	pending -= 1
	if pending > 0:
		_start_timer()


func _create_wave(_chasers: int) -> Wave:
	var _wave := wave.instance() as Wave
	_wave.speed = speed
	_wave.use_hitbox = true
	add_child(_wave)

	for _index in range(0, _chasers):
		var _chaser := chaser.instance()
		_wave.add_chaser(_chaser)
		_chaser.speed = speed

	return _wave
