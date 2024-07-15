@tool
extends BlankTexture
class_name CheckerboardTexture

@export var primary_color := Color.DIM_GRAY :
	set(new_primary_color):
		primary_color = new_primary_color
		create_image()

@export var secondary_color := Color.DARK_GRAY :
	set(new_secondary_color):
		secondary_color = new_secondary_color
		create_image()

@export var cell_size := Vector2i(8.0, 8.0) :
	set(new_cell_size):
		cell_size = new_cell_size.clamp(Vector2i.ONE, resolution)
		create_image()

func create_image() -> void:
	fully_opaque = primary_color.a == 1.0 and secondary_color.a == 1.0
	image = Image.create(resolution.x, resolution.y, false, Image.FORMAT_RGBAF)
	image.fill(primary_color)
	for y: int in range(1 + ceili(resolution.y / cell_size.y)):
		for x: int in range(ceili(0.5 * resolution.x / cell_size.x)):
			var position: Vector2i
			if y % 2:
				position = Vector2i(2.0 * x, y) * cell_size
			else:
				position = Vector2i(2.0 * x, y) * cell_size + cell_size * Vector2i.RIGHT
			image.fill_rect(Rect2i(position, cell_size), secondary_color)
	update_texture_rid()
