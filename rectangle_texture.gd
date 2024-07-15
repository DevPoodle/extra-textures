@tool
extends BlankTexture
class_name RectangleTexture

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

func create_image() -> void:
	image = Image.create(resolution.x, resolution.y, false, Image.FORMAT_RGBAF)
	fully_opaque = color.a == 1.0
	if border_size:
		fully_opaque = fully_opaque and border_color.a == 1.0
		image.fill(border_color)
		image.fill_rect(Rect2i(Vector2i.ONE * border_size, resolution - 2 * Vector2i.ONE * border_size), color)
	else:
		image.fill(color)
	update_texture_rid()
