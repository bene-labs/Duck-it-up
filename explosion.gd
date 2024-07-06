extends AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	play("default")
	var ui = get_tree().get_first_node_in_group("ui")
	animation_finished.connect(ui.finished)
