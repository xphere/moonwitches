extends NinePatchRect
class_name Dialog

signal completed()

onready var _name := $MarginContainer/HBoxContainer/Name
onready var _text := $MarginContainer/HBoxContainer/Text
onready var _animation := $MarginContainer/Outer/Inner/AnimationPlayer
var should_be_visible := 0
var writing := false


func _ready() -> void:
	set_process_input(false)
	if owner:
		visible = false


func text(name: String, text: String, chars_per_second: float) -> void:
	should_be_visible += 1
	_animation.play("Reset")
	_text.visible_characters = 0
	_name.text = name
	_text.text = text
	if should_be_visible > 0:
		visible = true
		set_process_input(true)
	writing = true
	_animation.playback_speed = chars_per_second / text.length()
	_animation.play("Play")


func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	writing = false


func _input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.is_pressed() or event.is_echo():
		return

	if writing:
		_animation.seek(1.0, true)
		writing = false

	else:
		emit_signal("completed")
		should_be_visible -= 1
		if should_be_visible <= 0:
			visible = false
			set_process_input(false)
