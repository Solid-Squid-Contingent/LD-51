shader_type canvas_item;

uniform vec4 offsets = vec4(1.0, 1.0, 1.0, 1.0);

void vertex(){
	VERTEX += vec2(sin(offsets.x * TIME * 10.0 + offsets.y * VERTEX.x * 300.0 + offsets.z * VERTEX.y * 200.0)*20.0, 0);
}