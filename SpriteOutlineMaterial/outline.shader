shader_type spatial;
render_mode blend_add,depth_draw_opaque,cull_disabled,diffuse_burley,specular_schlick_ggx;
uniform vec4 albedo : hint_color;
uniform sampler2D texture_albedo : hint_albedo;


// custom values:
uniform float line_size = 0.01;
uniform vec4 line_color = vec4(0, 0.8, 0.8, 1);
uniform float line_intensity = 0.01;
uniform float line_lod = 0.0;


// modified to needs:
void fragment() {
	vec2 base_uv = UV;
	vec4 albedo_tex = texture(texture_albedo, base_uv);
	
	vec3 color = albedo.rgb * albedo_tex.rgb; // buffer for color
	float alpha = albedo.a * albedo_tex.a;    // buffer for alpha value
	
	vec2 shifts[] = { vec2(-1, -1), vec2(0, -1), vec2(1, -1),
					  vec2(-1, 0),  vec2(0, 0),  vec2(1, 0),
					  vec2(-1, 1),  vec2(0, 1),  vec2(1, 1) }; // upper left to lower right
	
	/*
	float Gx[] = {  -1.0, 0.0, 1.0,
					-2.0, 0.0, 2.0,
					-1.0, 0.0, 1.0 }; // Sobel operator for x-edges
	float Gy[] = { -1.0, -2.0, -1.0,
					0.0,  0.0,  0.0,
					1.0,  2.0,  1.0 }; // Sobel operator for y-edges
	*/
	
	// I replaced the Sobel operators with the Scharr operator for better symmetry
	float Gx[] = {   47.0, 0.0,  -47.0,
				 	162.0, 0.0, -162.0,
					 47.0, 0.0,  -47.0 };
	float Gy[] = {   47.0,  162.0, -47.0,
					  0.0,    0.0,   0.0,
					-47.0, -162.0, -47.0 };
	
	float sGx;
	float sGy;
	
	// perform operation:
	for (int i = 0; i < 9; i++) {
		sGx += Gx[i] * textureLod(texture_albedo, base_uv + line_size * shifts[i], line_lod).a;
		sGy += Gy[i] * textureLod(texture_albedo, base_uv + line_size * shifts[i], line_lod).a;
	}
	
	float sG = sqrt(sGx*sGx + sGy*sGy) * line_intensity; // get dimensionless number
	
	if (alpha < 0.01) { // this value might be a handy shader parameter too
		alpha = sG * line_color.a;
		color = line_color.rgb;
	}
	
	ALBEDO = color;
	ALPHA = alpha;
}
