extends Control
@onready var button: Button = $CanvasLayer/CenterContainer/Button



func _on_button_button_up() -> void:
	get_tree().change_scene_to_file("res://Maps/loby_1/loby_1.tscn")
