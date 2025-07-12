extends Control
@onready var num_finished_label: Label = $CanvasLayer/VBoxContainer/num_finished_label
@onready var reward_label: Label = $CanvasLayer/VBoxContainer/reward_label
@onready var back_btn: Button = $CanvasLayer/VBoxContainer/HBoxContainer/back_btn


func set_finish_result(position: int, reward):
	var pos_str: Array = ["ro", "st", "nd", "rd", "th"]
	if position < 4:
		num_finished_label.set_text(str(position) + pos_str[position])
	else:
		num_finished_label.set_text(str(position) + pos_str[4])
		
	reward_label.set_text("You reward: " + str(reward))


func _on_back_btn_button_up() -> void:
	get_tree().change_scene_to_file("res://Maps/loby_1/loby_1.tscn")
