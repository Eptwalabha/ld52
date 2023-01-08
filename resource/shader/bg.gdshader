shader_type canvas_item;

uniform vec3 sand_color : source_color = vec3(0, 0., 0.165);


void fragment() {
	COLOR.rgb = sand_color;
	if (UV.y < .5) {
		COLOR.a = 0.;
	}
}
