shader_type spatial;
uniform vec3 main_color : source_color;
void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = main_color;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
