shader_type canvas_item;

uniform vec4 day_color : source_color = vec4(0.4, 0.7, 0.8, 1.);
uniform vec4 night_color : source_color = vec4(0., 0., 0., 1.);
uniform float time : hint_range(0., 1.) = 0.;
uniform sampler2D day_night;

void fragment() {
	vec4 amount = texture(day_night, vec2(time));
	COLOR = mix(day_color, night_color, amount.x);
}
