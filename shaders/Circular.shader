shader_type canvas_item;
render_mode blend_mix;

uniform float progress : hint_range(0.0, 1.0) = 0.0;

void fragment() {
	vec2 vec = UV - vec2(0.5);
	float visibility = step(180.0 + degrees(atan(-vec.x, vec.y)), 360.0 * progress);
	COLOR = texture(TEXTURE, UV);
	COLOR.a *= visibility;
}
