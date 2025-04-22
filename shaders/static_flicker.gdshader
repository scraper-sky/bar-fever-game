shader_type canvas_item;

   uniform float time_scale = 10.0;
   uniform float noise_density = 50.0;
   uniform float flicker_speed = 5.0;

   float random(vec2 uv) {
       return fract(sin(dot(uv, vec2(12.9898, 78.233))) * 43758.5453);
   }

   void fragment() {
       vec2 uv = SCREEN_UV;
       float noise = random(uv * noise_density + TIME * time_scale);
       float flicker = sin(TIME * flicker_speed) * 0.3 + 0.7; // Flicker between 0.4 and 1.0
       vec4 color = vec4(vec3(noise), 0.3 * flicker); // Gray static with transparency
       COLOR = color;
   }

