extends StaticBody2D


func is_point_inside(point: Vector2):
	return Geometry2D.is_point_in_polygon(point, $CollisionPolygon2D.polygon)
