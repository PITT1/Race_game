extends HBoxContainer
var global_var = load("res://global_var.gd").new()
@onready var money_label: Label = $money_label
var real_part: Array

func _ready() -> void:
	var data = JSON.parse_string(global_var.load_data())
	var str_money: String = str(data.money) 
	if str_money.contains("."):
		real_part = str_money.split(".")
		money_label.text = "$" + str(real_part[0])

func reset_money():
	var data = JSON.parse_string(global_var.load_data())
	var str_money: String = str(data.money) 
	if str_money.contains("."):
		real_part = str_money.split(".")
		money_label.text = "$" + str(real_part[0])
