shader_type canvas_item;

uniform vec4 offsets = vec4(1.0, 1.0, 1.0, 1.0);

uniform float disintegrationProgress = 0;
uniform float pixelSize = 1.0;

float random(vec2 co)
{
    float a = 12.9898;
    float b = 78.233;
    float c = 43758.5453;
    float dt= dot(co.xy ,vec2(a,b));
    float sn= mod(dt,3.14);
    return fract(sin(sn) * c);
}

void vertex(){
	VERTEX += vec2(sin(offsets.x * TIME * 10.0 + offsets.y * VERTEX.x * 300.0 + offsets.z * VERTEX.y * 200.0)*20.0, 0);
}

void fragment(){
	if (random(floor(UV / TEXTURE_PIXEL_SIZE / pixelSize)) < disintegrationProgress)
	{
		discard;
	}
}