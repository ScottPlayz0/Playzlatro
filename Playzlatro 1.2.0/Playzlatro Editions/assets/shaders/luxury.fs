#if defined(VERTEX) || __VERSION__ > 100 || defined(GL_FRAGMENT_PRECISION_HIGH)
	#define PRECISION highp
#else
	#define PRECISION mediump
#endif

extern PRECISION vec2 gold;

extern PRECISION number dissolve;
extern PRECISION number time;
extern PRECISION vec4 texture_details;
extern PRECISION vec2 image_details;
extern bool shadow;
extern PRECISION vec4 burn_colour_1;
extern PRECISION vec4 burn_colour_2;

extern PRECISION vec2 lines_offset;
extern PRECISION vec2 luxury;

// provided at bottom of file as in your original shader:
extern PRECISION vec2 mouse_screen_pos;
extern PRECISION float hovering;
extern PRECISION float screen_scale;

#define TWO_PI 6.28318530718

// Metallic palette (balanced values)
vec3 silver_color = vec3(0.70, 0.74, 0.80);
vec3 blue_color   = vec3(0.25, 0.50, 0.95);

vec4 dissolve_mask(vec4 final_pixel, vec2 texture_coords, vec2 uv);

// small helper: luminance
float lum_of(vec3 c){
    return dot(c, vec3(0.299, 0.587, 0.114));
}

bool line(vec2 uv, float offset, float width) {
    uv.x = uv.x * texture_details.z / texture_details.w;

    offset += 0.35 * sin(gold.x + TWO_PI * lines_offset.x);
    width  += 0.005 * sin(gold.x);

    float min_y = -uv.x + offset;
    float max_y = -uv.x + offset + width;

    return uv.y > min_y && uv.y < max_y;
}

vec4 effect(vec4 colour, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    // --- uv / sampling ---
	vec2 uv = (((texture_coords)*(image_details)) - texture_details.xy*texture_details.zw)/texture_details.zw;
    vec4 pixel = Texel(texture, texture_coords);

    // preserve original luminance and small contrast boost
    float lum = lum_of(pixel.rgb);
    lum = pow(lum, 0.9);

    // --- sheen / band parameters (tweak these) ---
    float speed = 1.6 + gold.x * 0.2;
    float band_freq = 10.0;
    float band_width = 0.6;
    float osc_strength = 0.9;

    float t = time * speed;
    float band = 0.5 + 0.5 * sin(t + uv.x * band_freq);
    float band_shaped = pow(smoothstep(0.5 - band_width*0.5, 0.5 + band_width*0.5, band), 1.2);
    float oscill = mix(0.0, 1.0, band_shaped) * osc_strength;
    float slow_pulse = 0.5 + 0.5 * 0.25 * sin(t * 0.35 + gold.x);
    oscill = clamp(oscill * (0.6 + slow_pulse), 0.0, 1.0);

    // base metallic color
    vec3 metallic_mix = mix(silver_color, blue_color, oscill);
    vec3 base_col = metallic_mix * lum * 1.25;

    // --- compute an approximate per-pixel normal from luminance neighbors ---
    // safe neighbor offsets in UV (sample one texel left/right/up/down)
    vec2 texelUV = vec2(1.0 / max(image_details.x, 1.0), 1.0 / max(image_details.y, 1.0));
    float lC = lum_of(Texel(texture, texture_coords).rgb);
    float lR = lum_of(Texel(texture, texture_coords + vec2(texelUV.x, 0.0)).rgb);
    float lL = lum_of(Texel(texture, texture_coords - vec2(texelUV.x, 0.0)).rgb);
    float lU = lum_of(Texel(texture, texture_coords + vec2(0.0, texelUV.y)).rgb);
    float lD = lum_of(Texel(texture, texture_coords - vec2(0.0, texelUV.y)).rgb);

    // gradient (x,y)
    vec2 grad = vec2((lR - lL) * 0.5, (lU - lD) * 0.5);

    // parameters for converting gradient to normal
    float normal_strength = 5.0; // increase to exaggerate microfacet slopes
    vec3 n = normalize(vec3(-grad * normal_strength, 1.0)); // z points out of the surface

    // --- compute view & light vectors in the same space ---
    // view vector: approximate from screen_coords and mouse position (both in pixels)
    // fallback: if mouse not provided, use screen center as view origin (small tilt)
    vec2 screenSize = love_ScreenSize.xy; // <-- explicit .xy to avoid vec4->vec2 assignment error
    vec2 viewXY = (screen_coords - mouse_screen_pos) / max(screenSize.x, screenSize.y);
    // small z component to bias view direction forward
    vec3 V = normalize(vec3(viewXY * 1.2, 0.6)); // adjust z to change apparent camera tilt

    // light direction (slightly tilted)
    vec3 light_dir = normalize(vec3(0.3, -0.4, 0.85)); // tweak for direction of shine
    // optional light tilt influenced by gold.x
    float light_tilt = 0.15 * gold.x;
    light_dir.xy += light_tilt;
    light_dir = normalize(light_dir);

    // half-vector and angle terms
    vec3 H = normalize(light_dir + V);
    float NdotH = max(dot(n, H), 0.0);
    float NdotL = max(dot(n, light_dir), 0.0);
    float NdotV = max(dot(n, V), 0.0);

    // --- specular (microfacet-style simple approximation) ---
    float shininess = 40.0;        // higher = tighter highlight
    float specular_strength = 1.2; // overall intensity
    float spec = pow(NdotH, shininess) * specular_strength;

    // add fresnel/rim accent on grazing angles for metallic feel
    float fresnel_strength = 0.9;
    float fresnel_power = 2.5;
    float fresnel = fresnel_strength * pow(1.0 - NdotV, fresnel_power);

    // tint specular slightly toward blue near highlight
    vec3 specular_color = mix(vec3(1.0), blue_color, 0.35);

    // scale specular by band_shaped so sheen movement still matters
    vec3 specular = specular_color * (spec * (0.6 + 0.8 * band_shaped) + fresnel * 0.4);

    // subtle reflective shift (keeps blue reflections near highlights)
    float reflect_shift = sin((uv.x - uv.y) * 4.0 + t) * 0.03;
    vec3 reflection = mix(vec3(0.0), blue_color * 0.45, reflect_shift + 0.5) * (0.5 + 0.6 * band_shaped);

    // sheen lines (preserve original pattern, modulate by band_shaped)
    vec4 sheen = vec4(1.0, 1.0, 1.0, 0.08 * (0.8 + 0.4 * band_shaped));
    if (
        lines_offset.x > 0.0 &&
        (line(uv, 0.0, 0.07) || line(uv, 0.4, 0.1) || line(uv, 0.55, 0.1) ||
         line(uv, 1.3, 0.05) || line(uv, 1.8, 0.1)) ||
        (line(uv, -0.1, 0.13) || line(uv, 0.3, 0.05) ||
         line(uv, 0.8, 0.1) || line(uv, 1.3, 0.11) ||
         line(uv, 1.7, 0.07))
    ) {
        sheen.a *= 1.8 + 0.6 * band_shaped;
    }

    // final composite
    vec3 final_col = base_col;
    final_col += specular;
    final_col += reflection;
    final_col += sheen.rgb * sheen.a;

    // tonemap/clamp
    pixel.rgb = clamp(final_col, 0.0, 1.0);

    // prevent uniform optimization removal
    pixel.rgb += luxury.x * 0.000001;

    return dissolve_mask(pixel, texture_coords, uv);
}

/* --- keep your existing dissolve_mask() unchanged from your file --- */
/* paste your original dissolve_mask implementation here verbatim */
vec4 dissolve_mask(vec4 final_pixel, vec2 texture_coords, vec2 uv)
{
    if (dissolve < 0.001) {
        return vec4(shadow ? vec3(0.0) : final_pixel.xyz,
                    shadow ? final_pixel.a*0.3 : final_pixel.a);
    }

    float adjusted_dissolve = (dissolve*dissolve*(3.0-2.0*dissolve))*1.02 - 0.01;

    float t = time * 10.0 + 2003.0;
    vec2 floored_uv = (floor((uv*texture_details.ba)))/max(texture_details.b, texture_details.a);
    vec2 uv_scaled_centered = (floored_uv - 0.5) * 2.3 * max(texture_details.b, texture_details.a);

    vec2 field_part1 = uv_scaled_centered + 50.0*vec2(sin(-t / 143.6340), cos(-t / 99.4324));
    vec2 field_part2 = uv_scaled_centered + 50.0*vec2(cos( t / 53.1532),  cos( t / 61.4532));
    vec2 field_part3 = uv_scaled_centered + 50.0*vec2(sin(-t / 87.53218), sin(-t / 49.0000));

    float field = (1.0 + (
        cos(length(field_part1) / 19.483) +
        sin(length(field_part2) / 33.155) * cos(field_part2.y / 15.73) +
        cos(length(field_part3) / 27.193) * sin(field_part3.x / 21.92)
    ))/2.0;

    vec2 borders = vec2(0.2, 0.8);

    float res = (.5 + .5* cos((adjusted_dissolve) / 82.612 + (field - .5)*3.14))
    - (floored_uv.x > borders.y ? (floored_uv.x - borders.y)*(5.0 + 5.0*dissolve) : 0.0)*(dissolve)
    - (floored_uv.y > borders.y ? (floored_uv.y - borders.y)*(5.0 + 5.0*dissolve) : 0.0)*(dissolve)
    - (floored_uv.x < borders.x ? (borders.x - floored_uv.x)*(5.0 + 5.0*dissolve) : 0.0)*(dissolve)
    - (floored_uv.y < borders.x ? (borders.x - floored_uv.y)*(5.0 + 5.0*dissolve) : 0.0)*(dissolve);

    if (final_pixel.a > 0.01 && burn_colour_1.a > 0.01 && !shadow &&
        res < adjusted_dissolve + 0.8*(0.5-abs(adjusted_dissolve-0.5)) &&
        res > adjusted_dissolve) {

        if (res < adjusted_dissolve + 0.5*(0.5-abs(adjusted_dissolve-0.5))) {
            final_pixel.rgba = burn_colour_1.rgba;
        } else if (burn_colour_2.a > 0.01) {
            final_pixel.rgba = burn_colour_2.rgba;
        }
    }

    return vec4(shadow ? vec3(0.0) : final_pixel.xyz,
                res > adjusted_dissolve ?
                (shadow ? final_pixel.a*0.3 : final_pixel.a) : 0.0);
}

#ifdef VERTEX
vec4 position(mat4 transform_projection, vec4 vertex_position)
{
    if (hovering <= 0.0)
        return transform_projection * vertex_position;

    float mid_dist = length(vertex_position.xy - 0.5*love_ScreenSize.xy)
                     / length(love_ScreenSize.xy);

    vec2 mouse_offset = (vertex_position.xy - mouse_screen_pos.xy)/screen_scale;

    float scale = 0.2*(-0.03 - 0.3*max(0.0, 0.3-mid_dist))
                  * hovering * (length(mouse_offset)*length(mouse_offset))
                  / (2.0 - mid_dist);

    return transform_projection * vertex_position + vec4(0,0,0,scale);
}
#endif