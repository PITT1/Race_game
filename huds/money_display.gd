extends HBoxContainer
var global_var = load("res://global_var.gd").new()
@onready var money_label: Button = $money_label
var real_part: Array
var count: int = 0

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


func _on_money_label_button_up() -> void:
	count = count + 1
	if count > 20:
		get_tree().change_scene_to_file("res://huds/loby_menus/console.tscn")
