shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float fade : hint_range(0.0, 1.0) = 0.0;
uniform float pixel_size : hint_range(1.0, 100.0) = 4.0; // Increased range to 100.0
const vec2 SCREEN_RES = vec2(1024.0, 600.0);

void fragment() {
    vec2 coord = SCREEN_UV * SCREEN_RES;
    vec2 block = floor(coord / pixel_size) * pixel_size;
    vec2 pix_uv = block / SCREEN_RES;
    vec4 scene_col = texture(screen_texture, pix_uv);
    COLOR = mix(scene_col, vec4(0.0), fade);
}