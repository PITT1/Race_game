extends Control
var global_var = load("res://global_var.gd").new()


func _ready() -> void:
	global_var.init_save_game()


func _on_button_button_up() -> void:
	get_tree().reload_current_scene()
