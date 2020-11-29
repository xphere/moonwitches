extends NinePatchRect
class_name Dialog

signal completed()

onready var _name := $MarginContainer/HBoxContainer/Name
onready var _text := $MarginContainer/HBoxContainer/Text
onready var _animation := $MarginContainer/Outer/Inner/AnimationPlayer
onready var _bubble := $Bubble
onready var _default_color := self_modulate
var should_be_visible := 0
var writing := false
var _profiles := {}
var _talkers := {}


func _ready() -> void:
	remove_child(_bubble)
	set_process_input(false)
	if owner:
		visible = false


func config(_profile: String, _color: Color, character_name: String) -> void:
	_profiles[_profile] = {
		color = _color,
		name = character_name,
	}


func set_talker(_profile: String, talker: Node2D) -> void:
	_talkers[_profile] = talker


func text(profile: String, text: String, chars_per_second: float) -> void:
	should_be_visible += 1
	_animation.play("Reset")
	_text.visible_characters = 0

	var _profile : Dictionary = _profiles[profile] if _profiles.has(profile) else {
		color = _default_color,
		name = profile,
	}

	self_modulate = _profile.color
	_name.text = _profile.name
	_text.text = text

	if _talkers.has(profile):
		(_talkers[profile] as Node).add_child(_bubble)
		_bubble.z_index = 1024
		_bubble.get_node("AnimationPlayer").play("Pop")
	else:
		_bubble.visible = false

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
		_bubble.get_parent().remove_child(_bubble)
		should_be_visible -= 1
		if should_be_visible <= 0:
			visible = false
			set_process_input(false)
