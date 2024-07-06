extends ReferenceRect

@export var bread_selection : Array[BreadData]
@export var bread_scene : PackedScene

@export var obstacles : Node2D
@export var ducks : Node2D

@export var min_spawn_delay := 0.5
@export var max_spawn_delay = 10.0
@export var min_duck_distance := 1000
@export var min_obstacle_distance = 500

@onready var rng = RandomNumberGenerator.new()


func _ready() -> void:
	rng.randomize()
	spawn_bread()
	restart_timer()


func pick_random_bread() -> BreadData:
	var total_weight = 0
	for bread : BreadData in bread_selection:
		total_weight += bread.spawn_chance
	var hit = rng.randi_range(0, total_weight)
	var hit_indx = 0
	for bread : BreadData in bread_selection:
		hit_indx += bread.spawn_chance
		if hit_indx >= hit:
			return bread
	return bread_selection[-1]


func spawn_bread():
	var bread_data = pick_random_bread()
	var is_valid_positon = false
	var new_bread : Bread = bread_scene.instantiate()
	var new_position
	new_bread.load_from_data(bread_data)
	while !is_valid_positon:
		var rect = get_global_rect()
		new_position = Vector2.ZERO
		new_position.x = rng.randf_range(rect.position.x, rect.size.x)
		new_position.y = rng.randf_range(rect.position.y,  rect.size.y)
		
		for duck: Duck in ducks.get_children():
			var dist = abs(new_bread.global_position.distance_to(duck.global_position))
			if dist <= min_duck_distance:
				continue
		for obstacle: Obstacle in obstacles.get_children():
			var dist = abs(new_bread.global_position.distance_to(obstacle.global_position))
			if dist <= min_obstacle_distance:
				continue
		is_valid_positon = true
	new_bread.global_position = new_position
	add_child(new_bread)

func restart_timer():
	$Timer.wait_time = rng.randf_range(min_spawn_delay, max_spawn_delay)
	$Timer.start()

func _on_timer_timeout() -> void:
	spawn_bread()
	restart_timer()
