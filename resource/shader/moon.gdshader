shader_type canvas_item;

uniform float progression : hint_range(0.0, 1.) = 0.;

vec3 sphere_normal(vec2 uv) {
	return vec3(uv, 1. - clamp(dot(uv, uv), 0., 1.));
}

void fragment() {
	vec2 uv = UV * 2. - 1.;
	vec3 a = vec3(sin(progression * PI), 0., -cos(progression * PI));
	float d = smoothstep(-.15, .15, dot(sphere_normal(uv), a));
	COLOR.rgb = mix(vec3(0.05), texture(TEXTURE, UV).rgb, d);
	COLOR.a = smoothstep(1., .95, length(uv));
}
