shader_type canvas_item;

uniform float amount = 0.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, filter_linear_mipmap;

void fragment() {
	// godot rewiring
	vec2 iResolution = 1.0 / SCREEN_PIXEL_SIZE;
	vec4 fragCoord = FRAGCOORD;
	vec2 p = fragCoord.xy / iResolution.x;//normalized coords with some cheat
	                                                         //(assume 1:1 prop)
	float prop = iResolution.x / iResolution.y;//screen proroption
	vec2 m = vec2(0.5, 0.5 / prop);//center coords
	vec2 d = p - m;//vector from center to current fragment
	float r = sqrt(dot(d, d)); // distance of pixel from center

	float power = amount;

	float bind;//radius of 1:1 effect
	if (power > 0.0) 
        bind = sqrt(dot(m, m));//stick to corners
	else {if (prop < 1.0) 
        bind = m.x; 
    else 
        bind = m.y;}//stick to borders

	//Weird formulas
	vec2 uv;
	if (power > 0.0)//fisheye
		uv = m + normalize(d) * tan(r * power) * bind / tan( bind * power);
	else if (power < 0.0)//antifisheye
		uv = m + normalize(d) * atan(r * -power * 10.0) * bind / atan(-power * bind * 10.0);
	else uv = p;//no effect for power = 1.0
        
    uv.y *= prop;

	vec3 col = texture(SCREEN_TEXTURE, uv).rgb;
    
    // inverted
	//vec3 col = texture(iChannel0, vec2(uv.x, 1.0 - uv.y)).rgb;//Second part of cheat
	                                                  //for round effect, not elliptical
	COLOR = vec4(col, 1.0);
}
