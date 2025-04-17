shader_type canvas_item;
render_mode unshaded;

uniform float glow_strength : hint_range(0.0, 1.0) = 0.5;
uniform float glow_size     : hint_range(1.0, 8.0) = 3.0;

void fragment() {
    vec4 base = texture(TEXTURE, UV) * COLOR;

    // accumulate a simple 1D blur along Y (for a horizontal laser)
    vec4 glow = vec4(0.0);
    float total = 0.0;
    for (int i = -4; i <= 4; i++) {
        float w = exp(-float(i*i) / (2.0 * glow_size * glow_size));
        vec2 off = vec2(0.0, float(i) * 1.0 / TEXTURE_PIXEL_SIZE.y);
        glow += texture(TEXTURE, UV + off) * COLOR * w;
        total += w;
    }
    glow /= total;

    // mix the base beam with its blown‑out blur
    COLOR = mix(base, glow, glow_strength);
}
