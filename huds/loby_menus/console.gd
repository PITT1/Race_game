extends Control
@onready var line_edit: LineEdit = $CanvasLayer/CenterContainer/LineEdit
@onready var button: Button = $CanvasLayer/Button
var global_var = load("res://global_var.gd").new()


func _on_button_button_up() -> void:
	if line_edit.text == "robin hood":
		var data = JSON.parse_string(global_var.load_data())
		data.money += 150000
		print("añadiendo 150.000$")
		global_var.save_data(JSON.stringify(data))
		get_tree().change_scene_to_file("res://Maps/loby_1/loby_1.tscn")
	else:
		get_tree().change_scene_to_file("res://Maps/loby_1/loby_1.tscn")
