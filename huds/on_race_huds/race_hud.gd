extends Control
@onready var lap_label: Label = $CanvasLayer/MarginContainer/lap_label
@onready var position_label: Label = $CanvasLayer/MarginContainer2/position_label



var car: VehicleBody3D = null
@onready var race_list: Array = []
var label_text: String = ""
var previous_lap: int = 0
var previous_pos: int = 0
var laps_to_finish: int

func _ready() -> void:
	car = get_parent()
	laps_to_finish = get_parent().get_parent().laps_num_to_finish

func _physics_process(delta: float) -> void:
	if delta:
		pass
	
	show_position()
	
	show_laps()
	

func show_position():
	if get_parent().get_parent().is_race == true:
		race_list = get_parent().get_parent().race_order
		
		for i in race_list.size():
			if race_list[i] == car:
				if i != previous_pos:
					label_text = "pos: " + str(i + 1) + "/" + str(race_list.size())
					position_label.set_text(label_text)
					previous_pos = i
	else:
		position_label.visible = false
		lap_label.visible = false

func show_laps():
	if car.laps_num != previous_lap:
		lap_label.text = "lap: " + str(car.laps_num) + "/" + str(laps_to_finish)
		previous_lap = car.laps_num
