extends RigidBody2D

@export var roation_speed := 40000.0
@export var acceleration_speed := 1500.0
@export var break_speed := 1800.0

var move_direction := Vector2.ZERO
var rotation_velocity := 0.0


func _input(event: InputEvent) -> void:
	move_direction = Vector2.ZERO
	rotation_velocity = 0.0
	if Input.is_action_pressed("turn_left"):
		rotation_velocity = -roation_speed 
	elif Input.is_action_pressed("turn_right"):
		rotation_velocity = roation_speed
	
	if Input.is_action_pressed("accelerate"):
		move_direction.y = -acceleration_speed 
	elif Input.is_action_pressed("break"):
		move_direction.y = break_speed
	move_direction = move_direction.rotated(rotation)



func _physics_process(delta: float) -> void:
	apply_central_force(move_direction * delta)
	apply_torque(rotation_velocity * delta)
