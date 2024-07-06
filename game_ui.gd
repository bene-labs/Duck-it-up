extends CanvasLayer

signal time_over(winnner)


var time_left = 150.0:
	set(value):
		time_left = value
		var minute = time_left / 60
		var second = int(time_left) % 60 
		var mili_sec = (time_left - int(time_left)) * 100
		$Time.text = "%d:%02d.%02d" % [minute, second, mili_sec]

var score1 = 0
var score2 = 0
var is_over := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func finished():
	is_over = true
	if score1 >= score2:
		$ResultScreen1.show()
	else:
		$ResultScreen2.show()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if is_over:
		return
	time_left -= delta
	if (time_left <= 0):
		time_over.emit(1 if score1 >= score2 else 2)


func _on_duck_2_points_changed(new_value: Variant) -> void:
	score2 = new_value
	$VBoxContainer/Player2Score.text = "Player 2: %d" % new_value


func _on_duck_points_changed(new_value: Variant) -> void:
	$VBoxContainer/Player1Score.text = "Player 1: %d" % new_value
	score1 = new_value


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
