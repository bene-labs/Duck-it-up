extends RigidBody2D


@export var roation_speed := 40000.0
@export var acceleration_speed := 1500.0
@export var break_speed := 1800.0

@export var player_number = 1

var roatate_left_action = "turn_left" + str(player_number)
var roatate_right_action = "turn_right" + str(player_number)
var accelerate_action = "accelerate" + str(player_number)
var break_action = "break" + str(player_number)

var move_direction := Vector2.ZERO
var rotation_velocity := 0.0


func _input(event: InputEvent) -> void:
	move_direction = Vector2.ZERO
	rotation_velocity = 0.0
	if Input.is_action_pressed(roatate_left_action):
		rotation_velocity = -roation_speed 
	elif Input.is_action_pressed(roatate_right_action):
		rotation_velocity = roation_speed
	
	if Input.is_action_pressed(accelerate_action):
		move_direction.y = acceleration_speed 
	elif Input.is_action_pressed(break_action):
		move_direction.y = -break_speed
	move_direction = move_direction.rotated(rotation)



func _physics_process(delta: float) -> void:
	apply_central_force(move_direction * delta)
	apply_torque(rotation_velocity * delta)
