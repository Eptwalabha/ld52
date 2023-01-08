shader_type canvas_item;

uniform vec3 day_color : source_color = vec3(0.4, 0.7, 0.8);
uniform vec3 night_color : source_color = vec3(0, 0.00784313771874, 0.16470588743687);
uniform float time : hint_range(0., 1.) = 0.;
uniform sampler2D day_night;

float rand21(vec2 uv) {
	return fract(sin(dot(uv.xy ,vec2(13.7952, 738.233))) * 43758.5453);
}

float stars(vec2 p) {
	vec2 p2 = p * vec2(400., 300.);
	vec2 id = floor(p2);
	float d = smoothstep(0.95, .99, rand21(id));
	if (d > 0.) {
		vec2 uv = fract(p2) - .5;
		float l = 1. - (length(uv) * 7.);
		return max(l * d, 0.);
	}
	return 0.;
} 

void fragment() {
	vec4 amount = texture(day_night, vec2(time));
	vec3 night = mix(night_color, vec3(1.), stars(UV));
	vec3 day = mix(day_color, vec3(1.), smoothstep(.4, .6, UV.y));
	COLOR.rgb = mix(day, night, amount.x);
}
