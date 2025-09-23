extends Control
@onready var lap_label: Label = $CanvasLayer/MarginContainer/lap_label
@onready var position_label: Label = $CanvasLayer/VBoxContainer/MarginContainer2/position_label
@onready var pause_btn: Button = $CanvasLayer/MarginContainer2/pause_btn
var PAUSE_HUD = preload("res://huds/on_race_huds/pause_hud.tscn")
@onready var canvas_layer: CanvasLayer = $CanvasLayer


var car: VehicleBody3D = null
@onready var race_list: Array = []
var label_text: String = ""
var previous_lap: int = 0
var previous_pos: int = 0
var laps_to_finish: int

func _ready() -> void:
	car = get_parent()
	laps_to_finish = get_parent().get_parent().laps_num_to_finish
	
	if car.get_parent().name == "Loby1":
		canvas_layer.visible = false
	else:
		canvas_layer.visible = true

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
					label_text = tr("id_14")+ " " + str(i + 1) + "/" + str(race_list.size())
					get_parent().position_from_hud = i + 1
					position_label.set_text(label_text)
					previous_pos = i
	else:
		position_label.visible = false
		lap_label.visible = false

func show_laps():
	if car.laps_num != previous_lap:
		lap_label.text = tr("id_13") + " " + str(car.laps_num) + "/" + str(laps_to_finish)
		previous_lap = car.laps_num


func _on_pause_btn_button_up() -> void:
	add_child(PAUSE_HUD.instantiate())
	get_tree().paused = true
