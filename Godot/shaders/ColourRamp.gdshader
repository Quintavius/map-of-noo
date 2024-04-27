shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform sampler2D gradient_texture : source_color;

void fragment(){
	float base = texture(screen_texture, SCREEN_UV).r;
	vec3 col = texture(gradient_texture, vec2(base,0)).xyz;
	
	float alpha = step(distance(UV, vec2(0.5, 0.5)),0.5);
	
	COLOR.rgb = col;
	COLOR.a = alpha;
}