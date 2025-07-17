extends Control
var global_var = load("res://global_var.gd").new()
@onready var money_label: Label = $CanvasLayer/money_label
var real_part: Array

func _ready() -> void:
	global_var.init_save_game()
	var data = JSON.parse_string(global_var.load_data())
	var str_money: String = str(data.money) 
	if str_money.contains("."):
		real_part = str_money.split(".")
		money_label.text = str(real_part[0])


func _on_button_button_up() -> void:
	get_tree().quit()
