class_name Obstacle
extends StaticBody2D

var poly : PackedVector2Array:
	get:
		var pol_list = []
		for pol in $NoSpawn/CollisionPolygon2D.polygon:
			pol_list.append(pol + global_position)
		return PackedVector2Array(pol_list)

func is_point_inside(point: Vector2):
	return Geometry2D.is_point_in_polygon(point, poly)

func is_polygon_inside(polygon: PackedVector2Array):
	return Geometry2D.intersect_polygons(polygon, poly)
