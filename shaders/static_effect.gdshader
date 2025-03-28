shader_type canvas_item;

uniform float intensity : hint_range(0.0, 1.0) = 0.3;  // Static strength
uniform float speed = 10.0;  // Noise movement speed
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;  // Add this line

float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    // Moving noise
    vec2 uv = UV + TIME * speed;
    float noise = random(uv);
    // RGB static for glitch effect
    float noise_r = random(uv);
    float noise_g = random(uv + vec2(1.0, 2.0));
    float noise_b = random(uv + vec2(3.0, 4.0));
    vec3 static_col = vec3(noise_r, noise_g, noise_b) * intensity;
    // Add scanlines
    float scanline = sin(UV.y * 800.0 + TIME * 10.0) * 0.1;
    static_col += vec3(scanline);
    // Blend with screen
    vec4 screen_col = texture(SCREEN_TEXTURE, SCREEN_UV);
    COLOR = mix(screen_col, vec4(static_col, 1.0), intensity);
    COLOR.a = intensity;  // Fade with intensity
}