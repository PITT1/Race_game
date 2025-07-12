extends Control
@onready var num_finished_label: Label = $CanvasLayer/VBoxContainer/num_finished_label
@onready var reward_label: Label = $CanvasLayer/VBoxContainer/reward_label
@onready var back_btn: Button = $CanvasLayer/VBoxContainer/HBoxContainer/back_btn
@export var reward_multiplier: Array = []
var reward_to_save: int
var global_var = load("res://global_var.gd").new()

func set_finish_result(position: int, reward):
	var pos_str: Array = ["ro", "st", "nd", "rd", "th"]
	if position < 4:
		num_finished_label.set_text(str(position) + pos_str[position])
	else:
		num_finished_label.set_text(str(position) + pos_str[4])
	if position < 4:
		reward_to_save = int(reward * reward_multiplier[position - 1])
		reward_label.set_text("You reward: " + str(reward_to_save))
	else:
		reward_to_save = int(reward * reward_multiplier[4])
		reward_label.set_text("You reward: " + str(reward_to_save))
	
	var data = JSON.parse_string(global_var.load_data())
	data.money += reward_to_save
	global_var.save_data(JSON.stringify(data))
	

func _on_back_btn_button_up() -> void:
	get_tree().change_scene_to_file("res://Maps/loby_1/loby_1.tscn")
