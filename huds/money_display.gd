extends HBoxContainer
var global_var = load("res://global_var.gd").new()
@onready var money_label: Button = $money_label
@onready var timer: Timer = $Timer
var real_part: Array
var count: int = 0
var on_change_up: bool = false
var on_change_down: bool = false
var num: int
var num_target: int
var direction: int = 0

func _ready() -> void:
	timer.stop()


func reset_money():
	var data = JSON.parse_string(global_var.load_data())
	num_target = data.money
	num = int(money_label.text)
	
	if num < num_target:
		direction = +1000
		timer.start()
	elif num > num_target:
		direction = -1000
		timer.start()

func _on_timer_timeout() -> void:
	num += direction
	money_label.text = str(num)
	
	if num >= num_target and direction > 0:
		money_label.text = str(num_target)
		timer.stop()
	elif num <= num_target and direction < 0:
		money_label.text = str(num_target)
		timer.stop()

func _on_money_label_button_up() -> void:
	count = count + 1
	if count > 20:
		get_tree().change_scene_to_file("res://huds/loby_menus/console.tscn")
