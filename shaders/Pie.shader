shader_type canvas_item;
render_mode blend_mix;

uniform float progress : hint_range(0.0, 1.0) = 0.0;
uniform float radius : hint_range(0.0, 1.0) = 0.3;
uniform vec4 background : hint_color;

void fragment() {
	vec2 vec = UV - vec2(0.5);
	COLOR.a = step(length(vec), radius);
	COLOR.rgb = mix(
		background.rgb,
		COLOR.rgb,
		step(180.0 + degrees(atan(-vec.x, vec.y)), 360.0 * progress)
	);
}