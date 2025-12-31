extends Control
@onready var line_edit: LineEdit = $CanvasLayer/CenterContainer/LineEdit
@onready var button: Button = $CanvasLayer/Button
var global_var = load("res://global_var.gd").new()


func _on_button_button_up() -> void:
	#add 150.000$
	if line_edit.text == "robin hood":
		var data = JSON.parse_string(global_var.load_data())
		data.money += 150000
		print("añadiendo 150.000$")
		global_var.save_data(JSON.stringify(data))
		get_tree().change_scene_to_file("res://Maps/loby_rework/loby_rework.tscn")
	else:
		get_tree().change_scene_to_file("res://Maps/loby_rework/loby_rework.tscn")
	
	# view frames per seconds
	
	if line_edit.text == "debug":
		var data: Dictionary = Options.load_data()
		if data.view_fps == false:
			data.view_fps = true
		else:
			data.view_fps = false
		Options.save_data(data)
