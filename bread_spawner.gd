extends ReferenceRect

@export var bread_selection : Array[BreadData]
@export var bread_scene : PackedScene

@export var obstacles : Node2D
@export var ducks : Node2D

@export var min_spawn_delay := 0.5
@export var max_spawn_delay = 10.0

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
	var new_bread : Bread = bread_scene.instantiate()
	new_bread.load_from_data(bread_data)
	while true:
		var rect = get_global_rect()
		new_bread.global_position.x = rng.randf_range(rect.position.x, rect.size.x)
		new_bread.global_position.y = rng.randf_range(rect.position.y,  rect.size.y)
		var macthing_ducks = 0
		for duck: Duck in ducks.get_children():
			if duck.is_polygon_intersecting_no_spawn_area(new_bread.global_polygon):
				break
			macthing_ducks += 1
		if macthing_ducks != ducks.get_child_count():
			continue
		var matching_obstacles = 0
		for obstacle: Obstacle in obstacles.get_children():
			if obstacle.is_polygon_intersecting(new_bread.global_polygon):
				break
			matching_obstacles += 1
		if matching_obstacles == obstacles.get_child_count():
			break
	add_child(new_bread)


func restart_timer():
	$Timer.wait_time = rng.randf_range(min_spawn_delay, max_spawn_delay)
	$Timer.start()


func _on_timer_timeout() -> void:
	spawn_bread()
	restart_timer()
