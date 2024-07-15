@tool
extends BlankTexture
class_name CircleTexture

@export var color := Color.WHITE :
	set(new_color):
		color = new_color
		create_image()

@export var border_color := Color.BLACK :
	set(new_border_color):
		border_color = new_border_color
		create_image()

@export var border_size := 4:
	set(new_border_size):
		border_size = clampi(new_border_size, 0, mini(resolution.x, resolution.y) / 2)
		create_image()

@export var antialiased := false :
	set(new_antialiased):
		antialiased = new_antialiased
		create_image()

func initialize() -> void:
	fully_opaque = false

func create_image() -> void:
	image = Image.create(resolution.x, resolution.y, false, Image.FORMAT_RGBAF)
	if border_size:
		image.fill(Color(border_color, 0.0))
	else:
		image.fill(Color(color, 0.0))
	var center_of_image := resolution * 0.5
	var distance_to_edge := minf(center_of_image.x, center_of_image.y) - 1.0
	for x: int in range(resolution.x):
		for y: int in range(resolution.y):
			var point := Vector2(x + 0.5, y + 0.5)
			var distance := point.distance_to(center_of_image)
			if border_size:
				if distance < distance_to_edge:
					var distance_to_border = distance + border_size
					if distance < distance_to_edge - border_size:
						image.set_pixel(x, y, color)
					elif antialiased and distance - distance_to_edge + border_size < 1.0:
						image.set_pixel(x, y, border_color.lerp(color, 1.0 - distance + distance_to_edge - border_size))
					else:
						image.set_pixel(x, y, border_color)
				elif antialiased and distance - distance_to_edge < 0.9:
					image.set_pixel(x, y, Color(border_color, 1.0 - absf(distance - distance_to_edge)))
			else:
				if distance < distance_to_edge:
					if distance < distance_to_edge - border_size:
						image.set_pixel(x, y, color)
					else:
						image.set_pixel(x, y, border_color)
				elif antialiased and distance - distance_to_edge < 0.9:
					image.set_pixel(x, y, Color(color, 1.0 - absf(distance - distance_to_edge)))
	update_texture_rid()
