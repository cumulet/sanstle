shader_type spatial;
render_mode depth_draw_always, cull_disabled;
uniform vec3 color_shallow : source_color = vec3(0.01, 0.2, 0.3);
uniform sampler2D DEPTH_TEXTURE : hint_depth_texture;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {

    
	ALBEDO = vec3(0);
	ROUGHNESS = 0.0;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
