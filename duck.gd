class_name Duck
extends RigidBody2D

signal points_changed(new_value)

@export var roation_speed := 40000.0
@export var acceleration_speed := 1500.0
@export var break_speed := 1800.0

@export var sprite_texture : Texture2D
@export var quack_sound : AudioStream
@export var player_number = 1

@export_category("Sound")
@export var min_quack_pitch := 0.5
@export var max_quack_pitch := 1.5
@export var min_hit_pitch := 0.5
@export var max_hit_pitch := 1.5

@onready var roatate_left_action = "turn_left" + str(player_number)
@onready var roatate_right_action = "turn_right" + str(player_number)
@onready var accelerate_action = "accelerate" + str(player_number)
@onready var break_action = "break" + str(player_number)
@onready var quack_action = "quack" + str(player_number)

var poly : PackedVector2Array:
	get:
		var pol_list = []
		for pol in $AntiSpawnArea/CollisionPolygon2D.polygon:
			pol_list.append(pol + global_position)
		return PackedVector2Array(pol_list)

var move_direction := Vector2.ZERO
var rotation_velocity := 0.0
var points = 0:
	set(value):
		points = value
		points_changed.emit(points)
var rng = RandomNumberGenerator.new()

func _ready() -> void:
	rng.randomize()
	$QuackSound.stream = quack_sound
	%Sprite.texture = sprite_texture


func _input(event: InputEvent) -> void:
	move_direction = Vector2.ZERO
	rotation_velocity = 0.0
	if event.is_action_pressed(roatate_left_action):
		rotation_velocity = -roation_speed 
	elif event.is_action_pressed(roatate_right_action):
		rotation_velocity = roation_speed
	if event.is_action_pressed(accelerate_action):
		move_direction.y = acceleration_speed 
	elif event.is_action_pressed(break_action):
		move_direction.y = -break_speed
	move_direction = move_direction.rotated(rotation)
	
	if event.is_action_pressed(quack_action):
		$QuackSound.pitch_scale = rng.randf_range(min_quack_pitch, max_quack_pitch)
		$QuackSound.play()


func _physics_process(delta: float) -> void:
	apply_central_force(move_direction * delta)
	apply_torque(rotation_velocity * delta)


func eat(bread: Bread):
	points += bread.value


func is_point_in_no_spawn_area(point: Vector2):
	return Geometry2D.is_point_in_polygon(point, poly)


func is_polygon_in_no_spawn_area(polygon: PackedVector2Array):
	return Geometry2D.intersect_polygons(polygon, poly)


func _on_hit_sound_area_body_entered(body: Node2D) -> void:
	if body == self:
		return
	$HitSound.pitch_scale = rng.randf_range(min_hit_pitch, max_hit_pitch)
	$HitSound.play()
