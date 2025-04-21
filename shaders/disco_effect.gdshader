shader_type canvas_item;

uniform float speed : hint_range(0.1, 5.0) = 2.0; // Color cycle speed
uniform float pulse_strength : hint_range(0.0, 1.0) = 0.5; // Color pulse intensity
uniform float base_alpha : hint_range(0.0, 1.0) = 0.6; // Base transparency
uniform float alpha_pulse : hint_range(0.0, 0.5) = 0.2; // Alpha pulse amplitude
uniform float sparkle_density : hint_range(0.0, 0.1) = 0.01; // Sparkle frequency
uniform float sparkle_speed : hint_range(0.1, 5.0) = 3.0; // Sparkle twinkle speed

// Simple pseudo-random noise function
float rand(vec2 co) {
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void fragment() {
    // Sample sprite texture
    vec4 tex_color = texture(TEXTURE, UV);

    // Disco effect: cycle colors
    float r = sin(TIME * speed + 0.0) * 0.5 + 0.5; // Red
    float g = sin(TIME * speed + 2.0) * 0.5 + 0.5; // Green
    float b = sin(TIME * speed + 4.0) * 0.5 + 0.5; // Blue

    // Color pulse effect
    float pulse = sin(TIME * speed * 2.0) * pulse_strength + (1.0 - pulse_strength);

    // Alpha pulse (0.4-0.8 range)
    float alpha = base_alpha + sin(TIME * speed) * alpha_pulse;

    // Base disco color
    vec3 disco_color = vec3(r, g, b) * pulse;
    vec4 base_color = vec4(disco_color * tex_color.rgb, tex_color.a * alpha);

    // Sparkle effect
    vec3 sparkle_color = vec3(0.0);
    float sparkle = rand(UV * 100.0 + TIME * sparkle_speed);
    if (sparkle > 1.0 - sparkle_density) {
        // Rainbow sparkle colors
        float sr = sin(TIME * sparkle_speed + UV.x * 10.0) * 0.5 + 0.5;
        float sg = sin(TIME * sparkle_speed + UV.y * 10.0 + 2.0) * 0.5 + 0.5;
        float sb = sin(TIME * sparkle_speed + (UV.x + UV.y) * 10.0 + 4.0) * 0.5 + 0.5;
        // Twinkle intensity
        float twinkle = sin(TIME * sparkle_speed + rand(UV) * 6.283) * 0.5 + 0.5;
        sparkle_color = vec3(sr, sg, sb) * twinkle * tex_color.a;
    }

    // Combine disco and sparkles
    COLOR = vec4(base_color.rgb + sparkle_color, base_color.a);
}