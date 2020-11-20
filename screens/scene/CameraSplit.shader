shader_type canvas_item;
render_mode blend_mix;

uniform sampler2D pupil_view;
uniform vec4 split_color : hint_color;
uniform float split_width : hint_range(0.5, 10.0);
uniform vec2 viewport_size;
uniform vec2 mentor_position;
uniform vec2 pupil_position;
uniform bool split;

float xor(float lhs, float rhs) {
	return lhs * (1.0 - rhs) + rhs * (1.0 - lhs);
}

float distance_to_line(vec2 origin, float slope, vec2 point) {
	vec2 calc = (point - origin) * viewport_size;
	vec2 line = vec2(slope, 1.0) * viewport_size;

	return abs(line.y * calc.x + line.x * calc.y) / length(line);
}

float split_cameras(vec2 uv, float slope) {
	float split_line = (0.5 - uv.y) * slope + 0.5;
	float is_right = step(uv.x, split_line);
	float is_pupil_right = step(mentor_position.x, pupil_position.x);

	return xor(is_right, is_pupil_right);
}

float split_line(vec2 uv, float slope) {
	float distance_to_split = distance_to_line(vec2(0.5), slope, uv);

	return smoothstep(0.0, split_width, distance_to_split - split_width);
}

void fragment() {
	vec4 color = texture(TEXTURE, UV);

	if (split)  {
		vec2 delta = pupil_position - mentor_position;
		float slope = -delta.y / delta.x;
		color = mix(
			split_color,
			mix(
				color,
				texture(pupil_view, UV),
				split_cameras(UV, slope)
			),
			split_line(UV, slope)
		);
	}

	COLOR = color;
}
