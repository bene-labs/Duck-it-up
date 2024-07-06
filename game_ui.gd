extends CanvasLayer

var time_left = 150.0:
	set(value):
		time_left = value
		var minute = time_left / 60
		var second = int(time_left) % 60 
		var mili_sec = (time_left - int(time_left)) * 100
		$Time.text = "%d:%02d.%02d" % [minute, second, mili_sec]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	time_left -= delta


func _on_duck_2_points_changed(new_value: Variant) -> void:
	$VBoxContainer/Player2Score.text = "Player 2: %d" % new_value


func _on_duck_points_changed(new_value: Variant) -> void:
	$VBoxContainer/Player1Score.text = "Player 1: %d" % new_value
