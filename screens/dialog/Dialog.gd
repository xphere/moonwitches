extends NinePatchRect
class_name Dialog

signal completed()

export var _default_sound : AudioStream

onready var _name := $MarginContainer/HBoxContainer/Name
onready var _text := $MarginContainer/HBoxContainer/Text
onready var _animation := $MarginContainer/Outer/Inner/AnimationPlayer
onready var _bubble := $Bubble
onready var _audio := $AudioStreamPlayer
onready var _default_color := self_modulate
var should_be_visible := 0
var writing := false
var _profiles := {}
var _talkers := {}
var _time := 0.0


func _ready() -> void:
	remove_child(_bubble)
	set_process_input(false)
	if owner:
		visible = false


func add_profile(profile_name: String, profile: Dictionary) -> void:
	_profiles[profile_name] = profile


func set_talker(_profile: String, talker: Node2D) -> void:
	_talkers[_profile] = talker


func text(profile: String, text: String, chars_per_second: float) -> void:
	should_be_visible += 1
	_animation.play("Reset")
	_text.visible_characters = 0

	var _profile : Dictionary = _profiles[profile] if _profiles.has(profile) else {
		color = _default_color,
		sound = _default_sound,
		character_name = profile,
	}

	self_modulate = _profile.color
	_name.text = _profile.character_name
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
	_time = 0.25
	_audio.stream = _profile.sound

	_animation.playback_speed = chars_per_second / text.length()
	_animation.play("Play")
	set_process(true)


func _process(delta: float) -> void:
	if not writing:
		set_process(false)
		return

	_time += delta
	var limit := 0.1 + randf() * 0.2
	if _time < limit:
		return

	_time -= limit
	_audio.pitch_scale = 0.85 + 0.3 * randf()
	_audio.play()


func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	writing = false


func _input(event: InputEvent) -> void:
	if not event is InputEventKey or not event.is_pressed() or event.is_echo():
		return

	if writing:
		_animation.seek(1.0, true)
		writing = false

	elif should_be_visible > 0:
		emit_signal("completed")
		if _bubble.is_inside_tree():
			_bubble.get_parent().remove_child(_bubble)
		should_be_visible -= 1
		if should_be_visible <= 0:
			visible = false
			set_process_input(false)
