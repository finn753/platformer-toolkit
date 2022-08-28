//Shader from
//Brefish
//https://www.youtube.com/watch?v=osGYErgbTEE

shader_type canvas_item;
render_mode unshaded;
 
uniform float circle_size : hint_range(0.0, 1.05);
uniform float screen_width = 1024;
uniform float screen_height = 600;
 
void fragment() {
	float ratio = screen_width / screen_height;
	float dist = distance(vec2(0.5, 0.5), vec2(mix(0.5, UV.x, ratio), UV.y));
	COLOR.a = step(circle_size, dist);
}