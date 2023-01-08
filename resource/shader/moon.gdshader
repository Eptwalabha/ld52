shader_type canvas_item;

uniform float progression : hint_range(0.0, 1.) = 0.;
uniform sampler2D moon_normal_map;

void fragment() {
	vec3 norm = texture(moon_normal_map, UV).rgb * 2. - 1.;
	vec3 a = vec3(sin(progression * PI), 0., -cos(progression * PI));
	float d = smoothstep(-.1, .1, dot(norm, a));
	COLOR.rgb = mix(vec3(0.05), texture(TEXTURE, UV).rgb, d);
	COLOR.a = smoothstep(1., .99, length(UV * 2. - 1.));
}
