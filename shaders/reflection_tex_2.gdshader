shader_type spatial;

uniform vec3 albedo : source_color;
uniform vec3 albedo2 : source_color;
uniform float metallic : hint_range(0.0, 1.0) = 0;
uniform float roughness : hint_range(0.0, 1.0) = 0.02;
uniform sampler2D wave;
uniform sampler2D texture_normal;
uniform sampler2D texture_normal2;
uniform sampler2D texture_depth : hint_depth_texture;
uniform sampler2D texture_screen : hint_screen_texture;
uniform vec2 wave_direction = vec2(2.0, 0.0);
uniform vec2 wave_direction2 = vec2(0.0, 1.0);
uniform float time_scale : hint_range(0.0, 0.2, 0.005) = 0.025;
uniform float noise_scale = 10.0;
uniform float height_scale = 0.15;

uniform vec4 color_deep : source_color;
uniform vec4 color_shallow : source_color;
uniform float beers_law = 2.0;
uniform float depth_offset = -0.75;

uniform float edge_scale = 0.1;
uniform float near = 1.0;
uniform float far = 100.0;
uniform vec3 edge_color : source_color;

// Vertex-to-fragment varyings
varying float height;
varying vec3 world_pos;
varying vec3 world_normal;

// Compute a Fresnel term in world space
float fresnel_factor(float power, vec3 normal, vec3 view_dir) {
    return pow(1.0 - clamp(dot(normalize(normal), normalize(view_dir)), 0.0, 1.0), power);
}

// Linearize depth for edge detection
float edge_depth(float d) {
    d = 2.0 * d - 1.0;
    return near * far / (far + d * (near - far));
}

void vertex() {
    // World-space position and normal
    world_pos = (MODEL_MATRIX * vec4(VERTEX, 1.0)).xyz;
    world_normal = normalize((MODEL_NORMAL_MATRIX * NORMAL));

    // Apply wave height
    height = texture(wave, world_pos.xz / noise_scale + TIME * time_scale).r;
    VERTEX.y += height * height_scale;
}

void fragment() {
    // Depth-based water tint
    float depth_tex = texture(texture_depth, SCREEN_UV).r * 2.0 - 1.0;
    float depth = PROJECTION_MATRIX[3][2] / (depth_tex + PROJECTION_MATRIX[2][2]);
    float dp = exp((depth + world_pos.z + depth_offset) * -beers_law);
    dp = clamp(1.0 - dp, 0.0, 1.0);
    float dp_pow = clamp(pow(dp, 2.5), 0.0, 1.0);

    vec3 screen_col = texture(texture_screen, SCREEN_UV).rgb;
    vec3 depth_col = mix(color_shallow.rgb, color_deep.rgb, dp_pow);
    vec3 water_col = mix(screen_col * depth_col, depth_col * 0.25, dp_pow * 0.5);

    // Real screen-space reflection
    vec3 view_dir = normalize(CAMERA_POSITION_WORLD - world_pos);
    vec3 refl = reflect(-view_dir, world_normal);
    float reflect_dist = 5.0; // tweak to scene scale
    vec4 clip_refl = PROJECTION_MATRIX * VIEW_MATRIX * vec4(world_pos + refl * reflect_dist, 1.0);
    vec2 uv_refl = clip_refl.xy / clip_refl.w * 0.5 + 0.5;
    vec3 reflection = texture(texture_screen, uv_refl).rgb;

    // Fresnel-based blending
    float f = fresnel_factor(5.0, world_normal, view_dir);
    vec3 surface_col = mix(albedo, albedo2, f);

    // Edge highlighting
    float z_d = edge_depth(texture(texture_depth, SCREEN_UV).r);
    float z_p = edge_depth(FRAGCOORD.z);
    float zdiff = z_d - z_p;
    vec3 edge_highlight = edge_color * step(edge_scale, zdiff);

    // Compose final color
    vec3 final_col = surface_col + water_col + reflection * f * 0.5 + edge_highlight;
    ALBEDO = clamp(final_col, vec3(0.0), vec3(1.0));
    METALLIC = metallic;
    ROUGHNESS = roughness;

    // Normal map waves
    vec2 t1 = world_pos.xz + TIME * wave_direction * time_scale;
    vec2 t2 = world_pos.xz + TIME * wave_direction2 * time_scale;
    NORMAL_MAP = mix(texture(texture_normal, t1).rgb, texture(texture_normal2, t2).rgb, 0.5);
}
