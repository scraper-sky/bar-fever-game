shader_type canvas_item;

uniform float emission_strength = 0.1; // Adjust this value (0.0 to 1.0)

void fragment() {
    vec4 color = texture(TEXTURE, UV);
    color.rgb += color.rgb * emission_strength; // Boost brightness
    COLOR = color;
}