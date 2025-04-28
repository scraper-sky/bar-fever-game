shader_type canvas_item;

uniform float swirl_speed = 1.0;  // Speed of the swirling background
uniform float swirl_intensity = 0.3;  // Intensity of the swirling pattern
uniform float wave_frequency = 8.0;  // Frequency of the swirling waves
uniform float transparency = 0.5;  // Base transparency of the effect
uniform float glitch_intensity = 0.15;  // Intensity of the glitch effects
uniform float scanline_speed = 5.0;  // Speed of the scanline movement
uniform float scanline_density = 50.0;  // Density of the scanlines
uniform float noise_speed = 0.2;  // Speed of the noise distortion
uniform float pixelation_size = 0.02;  // Size of the pixelation effect
uniform float flicker_speed = 10.0;  // Speed of the transparency flicker
uniform vec3 tint_color = vec3(0.8, 0.6, 1.0);  // Subtle purple tint (RGB)

// Simple 2D noise function for randomness
float random(vec2 st) {
    return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123);
}

// 2D noise function for smoother distortion
float noise(vec2 st) {
    vec2 i = floor(st);
    vec2 f = fract(st);
    float a = random(i);
    float b = random(i + vec2(1.0, 0.0));
    float c = random(i + vec2(0.0, 1.0));
    float d = random(i + vec2(1.0, 1.0));
    vec2 u = f * f * (3.0 - 2.0 * f);
    return mix(a, b, u.x) + (c - a) * u.y * (1.0 - u.x) + (d - b) * u.x * u.y;
}

void fragment() {
    // Sample the sprite's texture to get its alpha
    vec4 tex_color = texture(TEXTURE, UV);
    float sprite_alpha = tex_color.a;

    // Center the UV coordinates (0 to 1 -> -0.5 to 0.5)
    vec2 centered_uv = UV - vec2(0.5);

    // Convert to polar coordinates for swirling effect
    float radius = length(centered_uv);
    float angle = atan(centered_uv.y, centered_uv.x);

    // Add time-based rotation for the swirl
    angle += TIME * swirl_speed;

    // Create a swirling background pattern
    float swirl = sin(radius * wave_frequency + angle + TIME * swirl_speed) * swirl_intensity;
    angle += swirl;

    // Add noise-based distortion
    vec2 noise_uv = centered_uv + TIME * noise_speed;
    float noise_value = noise(noise_uv * 3.0);
    vec2 distorted_uv = centered_uv + vec2(noise_value * glitch_intensity, noise_value * glitch_intensity);

    // Pixelation effect
    vec2 pixelated_uv = floor(distorted_uv / pixelation_size) * pixelation_size;

    // Recalculate angle for the distorted UVs
    float distorted_angle = atan(pixelated_uv.y, pixelated_uv.x) + TIME * swirl_speed + swirl;

    // Create a base color with subtle glitchy variations
    float base = sin(distorted_angle) * 0.5 + 0.5;
    // Add glitchy RGB noise
    float r_noise = noise(noise_uv + vec2(0.1, 0.0)) * 0.2;
    float g_noise = noise(noise_uv + vec2(0.2, 0.0)) * 0.2;
    float b_noise = noise(noise_uv + vec2(0.3, 0.0)) * 0.2;
    vec3 color = vec3(base + r_noise, base + g_noise, base + b_noise);

    // Apply a subtle tint
    color *= tint_color;

    // Add scanlines with random offsets
    float scanline_offset = random(vec2(UV.x, TIME * 0.1)) * glitch_intensity;
    float scanline = sin((UV.y + scanline_offset) * scanline_density + TIME * scanline_speed) * glitch_intensity;
    color += vec3(scanline);

    // Flicker the transparency
    float alpha_flicker = 1.0 + sin(TIME * flicker_speed) * 0.05;
    float base_alpha = sprite_alpha * transparency;
    float final_alpha = base_alpha * alpha_flicker;

    // Ensure fully transparent outside the sprite's shape
    if (sprite_alpha < 0.01) {
        final_alpha = 0.0;
    }

    // Output the final color with transparency
    COLOR = vec4(color, final_alpha);
}