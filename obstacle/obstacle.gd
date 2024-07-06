class_name Obstacle
extends StaticBody2D


var global_polygon:
	get:
		var global_poly = PackedVector2Array($CollisionPolygon2D.polygon)
		for i in range(global_poly.size()):
			global_poly[i] = to_global(global_poly[i])
		return global_poly


func is_point_inside(point: Vector2):
	return Geometry2D.is_point_in_polygon(point, global_polygon)

func is_polygon_intersecting(polygon: PackedVector2Array):
	return Geometry2D.intersect_polygons(polygon, global_polygon)
