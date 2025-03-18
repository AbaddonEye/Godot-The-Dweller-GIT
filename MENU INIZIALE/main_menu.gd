extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)  # Mostra il mouse
	$VBoxContainer/StartButton.pressed.connect(on_start_pressed)

func on_start_pressed():
	get_tree().change_scene_to_file("res://levels/scena_test.tscn")  # <-- Cambia questo con la tua scena
