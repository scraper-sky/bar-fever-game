shader_type canvas_item;

uniform float flash_speed = 3.0;
uniform float black_threshold = 0.1;  // Threshold to detect "black" pixels

float random(vec2 uv) {
    return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
}

vec3 hue_to_rgb(float hue) {
    hue = fract(hue);
    float r = abs(hue * 6.0 - 3.0) - 1.0;
    float g = 2.0 - abs(hue * 6.0 - 2.0);
    float b = 2.0 - abs(hue * 6.0 - 4.0);
    return clamp(vec3(r, g, b), 0.0, 1.0);
}

void fragment() {
    vec4 col = texture(TEXTURE, UV);

    // Calculate rainbow color and flicker
    float hue = random(vec2(UV.x + TIME * 0.2, UV.y + TIME * 0.2));
    vec3 rainbow = hue_to_rgb(hue);
    float flicker = sin(TIME * flash_speed + random(UV) * 10.0) * 0.5 + 0.5;
    vec3 flickered_rainbow = rainbow * flicker;

    // Detect black pixels (outline)
    float is_black = step(length(col.rgb), black_threshold);

    // Replace black outline with rainbow pixels
    if (is_black > 0.0) {
        col.rgb = flickered_rainbow;
    }

    // Optionally apply the effect to the transparent interior
    if (col.a > 0.0 && col.a < 1.0) {  // Partially transparent areas (interior)
        col.rgb = flickered_rainbow;
        col.a = 1.0;  // Make the interior fully visible
    }

    // Respect the sprite's alpha for the final output
    COLOR = vec4(col.rgb, col.a);
}