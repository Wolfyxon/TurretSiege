#pragma language glsl1

uniform vec4 color = vec4(1, 1, 1, 0);

vec4 effect(vec4 col, Image texture, vec2 texture_coords, vec2 screen_coords) {
    vec4 tex_color = Texel(texture, texture_coords);
    
    return tex_color + color;
}
