@tool
extends BlankTexture
class_name CircleTexture

@export var color := Color.WHITE :
	set(new_color):
		color = new_color
		create_image()

@export var antialiased := false :
	set(new_antialiased):
		antialiased = new_antialiased
		create_image()

func initialize() -> void:
	fully_opaque = false

func create_image() -> void:
	image = Image.create(resolution.x, resolution.y, false, Image.FORMAT_RGBAF)
	image.fill(Color(color, 0.0))
	var center_of_image := resolution * 0.5
	var distance_to_edge := minf(center_of_image.x, center_of_image.y) - 1.0
	for x: int in range(resolution.x):
		for y: int in range(resolution.y):
			var point := Vector2(x + 0.5, y + 0.5)
			var distance := point.distance_to(center_of_image)
			if distance < distance_to_edge:
				image.set_pixel(x, y, color)
			elif antialiased and distance - distance_to_edge < 0.9:
				image.set_pixel(x, y, Color(color, 1.0 - absf(distance - distance_to_edge)))
	update_texture_rid()
