shader_type canvas_item;

uniform vec4 offsets = vec4(1.0, 1.0, 1.0, 1.0);

void vertex(){
	VERTEX += vec2(sin(offsets.x * TIME * 10.0 + VERTEX.y * 200.0)*20.0, 0);
}

void fragment(){
	COLOR = texture(TEXTURE, UV) * vec4(
		0.7 + 0.3 * sin(offsets.x * (TIME * 20.0 + UV.y * 10.0)),
		0.7 + 0.3 * sin(offsets.y * (TIME * 2.0  + UV.x * 30.0)),
		0.7 + 0.3 * sin(offsets.z * (TIME * 7.0  + UV.y * 30.0)),
		0.7 + 0.3 * sin(offsets.w * (TIME * 10.0 + UV.x * 10.0)));
}