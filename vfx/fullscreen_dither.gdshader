// Applies viewport-wide dithering and pixelation

// Dithering element from https://github.com/griffinjennings/GodotDitheringShader/blob/master/Godot%20Dithering%20Shader.shader\

// Pixelation Effect
//https://gamedev.stackexchange.com/questions/111017/pixelation-shader-explanation
//https://www.geeks3d.com/20101029/shader-library-pixelation-post-processing-effect-glsl/

shader_type canvas_item;
render_mode unshaded;

uniform sampler2D dither_pattern;
uniform bool dither_enabled = true;
uniform bool greyscale = false;
uniform float greyscale_blend_amount = 0.0;
uniform float dither_amount = 1.0;
uniform int colours = 4;

uniform float pixel_width = 3.0;
uniform float pixel_height = 1.0;


float dither(float raw, float dither, int depth) {

	float div = 1.0 / float(depth);
	float val = 0.0;

	for (int i = 0; i < depth; i++) {
		if (raw <= div * (float(i + 1))) {
			if ((raw * float(depth)) - float(i) <= dither * 0.999) {
				val = div * float(i);
			} else {
				val = div * float(i + 1);
			}
			break;
		}
	}
	if (raw >= 1.0) {
		val = 1.0;
	}
	return val;
}

void fragment() {
	float Pixels_x = 1920.0;
	float Pixels_y = 1080.0;
	float dx = pixel_width * (1.0 / Pixels_x);
	float dy = pixel_height * (1.0 / Pixels_y);
	vec2 Coord = vec2(dx * floor(SCREEN_UV.x / dx),
                        dy * floor(SCREEN_UV.y / dy));
	vec4 raw = texture(TEXTURE, Coord);
	vec3 dither_pixel = texture(dither_pattern, Coord).rgb;
	if (dither_enabled == true) {
		// Blender between greyscale and normal colour based
		raw.rgb = mix(raw.rgb, vec3((raw.r + raw.g + raw.b) / 3.0), greyscale_blend_amount);

		COLOR.r = dither(raw.r, (dither_pixel.x - 0.5) * dither_amount + 0.5, colours - 1);
		COLOR.g  = dither(raw.g, (dither_pixel.x - 0.5) * dither_amount + 0.5, colours - 1);
		COLOR.b = dither(raw.b, (dither_pixel.x - 0.5) * dither_amount + 0.5, colours - 1);

	} else {
		COLOR.rgb = raw.rgb;
	}
	COLOR.a = raw.a;
}