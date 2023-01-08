shader_type canvas_item;

uniform vec4 sky_color : source_color;

void fragment() {
	COLOR = sky_color;
}
