shader_type canvas_item;

uniform sampler2D screen_tex : hint_screen_texture, source_color, filter_linear_mipmap;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	COLOR.rgb = mix(texture(screen_tex, SCREEN_UV, 4.5).rgb, COLOR.rgb, COLOR.a);
	COLOR.a = 1.0;
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
