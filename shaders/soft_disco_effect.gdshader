shader_type canvas_item;

uniform float pulse_speed = 0.5;  // Speed of the pulsing effect
uniform float color_shift = 0.3;  // Controls the intensity of the color transition
uniform float glow_intensity = 0.05;  // Intensity of the shimmer/glow effect

void fragment() {
    // Sample the original texture
    vec4 tex_color = texture(TEXTURE, UV);

    // Create a smooth time-based pulse using sin
    float pulse = 0.5 + 0.5 * sin(TIME * pulse_speed);

    // Create a blue-pink color gradient based on UV and time
    vec3 blue = vec3(0.2, 0.4, 0.8);  // Soft blue
    vec3 pink = vec3(0.8, 0.4, 0.6);  // Soft pink
    vec3 color_mix = mix(blue, pink, 0.5 + 0.5 * sin(UV.x + UV.y + TIME * color_shift));

    // Add a subtle shimmer effect using a noise-like pattern
    float shimmer = 0.5 + 0.5 * sin(UV.x * 10.0 + UV.y * 10.0 + TIME * 2.0);
    shimmer *= glow_intensity * pulse;

    // Combine the original texture with the color overlay and shimmer
    vec3 final_color = tex_color.rgb + (color_mix * pulse) + vec3(shimmer);

    // Preserve the original alpha channel
    COLOR = vec4(final_color, tex_color.a);
}