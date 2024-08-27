class_name Bread
extends Node2D

@export var value = 1
@export var spawn_chance = 1

var global_polygon:
	get:
		var global_poly = PackedVector2Array($Area2D/CollisionPolygon2D.polygon)
		for i in range(global_poly.size()):
			global_poly[i] = to_global(global_poly[i])
		return global_poly


func load_from_data(data: BreadData):
	scale = data.scale
	value = data.value
	spawn_chance = data.spawn_chance
	$Sprite2D.texture = data.texture
	$Area2D/CollisionPolygon2D.polygon = data.polygon


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.has_method('eat'):
		body.eat(self)
		queue_free()
