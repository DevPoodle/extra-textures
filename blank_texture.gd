@tool
extends Texture2D
class_name BlankTexture

# WARNING: If set as the atlas texture for a tileset, "Use Texture Padding" MUST be set to false

@export var resolution := Vector2i(32.0, 32.0) :
	set(new_resolution):
		resolution = new_resolution.clamp(Vector2i.ONE, 2048 * Vector2i.ONE)
		resolution_changed = true
		create_image()

var image: Image
var texture_rid: RID
var fully_opaque := true
var resolution_changed := false

func create_image() -> void:
	image = Image.create(resolution.x, resolution.y, false, Image.FORMAT_RGBAF)
	image.fill(Color.WHITE)
	update_texture_rid()

func update_texture_rid() -> void:
	if resolution_changed:
		var new_texture_rid = RenderingServer.texture_2d_create(image)
		RenderingServer.texture_replace(texture_rid, new_texture_rid)
		RenderingServer.free_rid(new_texture_rid)
		resolution_changed = false
	else:
		RenderingServer.texture_2d_update(texture_rid, image, 0)
	RenderingServer.texture_set_path(texture_rid, get_path())
	emit_changed()

func _init() -> void:
	initialize()
	image = Image.create(resolution.x, resolution.y, false, Image.FORMAT_RGBAF)
	image.fill(Color.WHITE)
	texture_rid = RenderingServer.texture_2d_create(image)
	create_image()

# Override in child classes for a second initialization function
func initialize() -> void:
	pass

func _get_rid() -> RID:
	return texture_rid;

func _draw(to_canvas_item: RID, pos: Vector2, modulate: Color, transpose: bool) -> void:
	RenderingServer.canvas_item_add_texture_rect(to_canvas_item, Rect2(pos, get_size()), get_rid(), false, modulate, transpose);

func _draw_rect(to_canvas_item: RID, rect: Rect2, tile: bool, modulate: Color, transpose: bool) -> void:
	RenderingServer.canvas_item_add_texture_rect(to_canvas_item, rect, get_rid(), tile, modulate, transpose);

func _draw_rect_region(to_canvas_item: RID, rect: Rect2, src_rect: Rect2, modulate: Color, transpose: bool, clip_uv: bool) -> void:
	RenderingServer.canvas_item_add_texture_rect_region(to_canvas_item, rect, get_rid(), src_rect, modulate, transpose, clip_uv);

func _get_height() -> int:
	return resolution.y

func _get_width() -> int:
	return resolution.x

func _has_alpha() -> bool:
	return !fully_opaque

func _is_pixel_opaque(x: int, y: int) -> bool:
	if fully_opaque:
		return true
	return image.get_pixel(x, y).a == 1.0

func _notification(what: int) -> void:
	if what == NOTIFICATION_PREDELETE:
		RenderingServer.free_rid(texture_rid)
