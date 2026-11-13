extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Window.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_window_close_requested() -> void:
	get_tree().quit()


func _on_button_pressed() -> void:
	$Window.show()


func _on_button1_pressed() -> void:
	$Window.show()
