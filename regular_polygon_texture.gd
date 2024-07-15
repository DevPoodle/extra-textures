@tool
extends BlankTexture
class_name RegularPolygonTexture

@export var color := Color.WHITE :
	set(new_color):
		color = new_color
		create_image()

@export var sides := 5 :
	set(new_sides):
		sides = clampi(new_sides, 3, 15)
		create_polygon()
		create_image()

@export var antialiased := false :
	set(new_antialiased):
		antialiased = new_antialiased
		create_polygon()
		create_image()

var polygon := PackedVector2Array([])

func initialize() -> void:
	fully_opaque = false
	create_polygon()
	
func create_polygon() -> void:
	polygon.clear()
	var center_of_image := resolution * 0.5
	for corner: int in range(sides):
		var angle := corner * (TAU / sides) - PI / 2.0
		if antialiased:
			polygon.append(center_of_image + Vector2.from_angle(angle) * (minf(center_of_image.x, center_of_image.y) - 1.0))
		else:
			polygon.append(center_of_image + Vector2.from_angle(angle) * (minf(center_of_image.x, center_of_image.y)))

func create_image() -> void:
	if resolution_changed:
		create_polygon()
	
	image = Image.create(resolution.x, resolution.y, false, Image.FORMAT_RGBAF)
	image.fill(Color(color, 0.0))
	for x: int in range(resolution.x):
		for y: int in range(resolution.y):
			var point := Vector2(x, y)
			if Geometry2D.is_point_in_polygon(point, polygon):
				image.set_pixelv(point, color)
			elif antialiased:
				var closest_distance := 1.0
				for side: int in range(polygon.size()):
					if side < polygon.size() - 1:
						var distance := Geometry2D.get_closest_point_to_segment(point, polygon[side], polygon[side + 1]).distance_to(point)
						if distance < closest_distance:
							closest_distance = distance
					else:
						var distance := Geometry2D.get_closest_point_to_segment(point, polygon[side], polygon[0]).distance_to(point)
						if distance < closest_distance: 
							closest_distance = distance
				if closest_distance < 0.9:
					image.set_pixelv(point, Color(color,1.0 - closest_distance))
	update_texture_rid()
