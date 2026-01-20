extends Node3D
var car_list_global: Dictionary

var global_var = load("res://global_var.gd").new()
var car_names: Array = []
@onready var spawner: Marker3D = $spawner
var selected_car_name: String = ""
var data_loaded: Dictionary
@onready var money_display: HBoxContainer = $CanvasLayer/MoneyDisplay
@onready var padlock_anim: Node3D = $PadlockAnim
@onready var anim: AnimationPlayer = $AnimationPlayer

#hud
@onready var car_name_label: Label = $CanvasLayer/car_name_label
@onready var car_num: Label = $CanvasLayer/car_num
@onready var select: Button = $CanvasLayer/select

#variables necesarias de escenas de los vehiculos
var laps_to_finish: int
var laps_num_to_finish: int = 0
var num_checkpoints: int = 0
var is_race = false

var candado_visible_anterior = false


func _ready() -> void:
	money_display.reset_money()
	data_loaded = JSON.parse_string(global_var.load_data())
	selected_car_name = data_loaded.car  #nombre del vehiculo seleccionado
	car_list_global = global_var.car_list
	car_names = car_list_global.keys()
	print(car_list_global[selected_car_name][0])
	car_name_label.text = selected_car_name
	car_num.text = str(car_names.find(selected_car_name))
	var car: PackedScene = load(car_list_global[selected_car_name][0])
	var car_instantia: VehicleBody3D = car.instantiate()
	car_instantia.position = spawner.position
	car_instantia.rotate_y(2)
	add_child(car_instantia)
	car_instantia.axis_lock_linear_x = true
	car_instantia.steering = 0.5
	
	


func _on_left_button_up() -> void:
	for item in get_children():
		if item.get_class() == "VehicleBody3D":
			item.queue_free()
	
	var car_num_hud = int(car_num.text) - 1
	var new_car_name = car_names[car_num_hud]
	car_name_label.text = new_car_name #nombre del vehiculo
	car_num.text = str(car_names.find(new_car_name)) #numero del vehiculo
	#print(car_list_global[new_car_name][1]) #precio del vehiculo
	#print(data_loaded.cars_data[new_car_name]) #si esta desponible: true, si no: falsee
	
	if data_loaded.cars_data[new_car_name]:
		select.text = tr("id_17") #seleccionar
	else:
		select.text = tr("id_16") + " $" + str(car_list_global[new_car_name][1])
	
	var car: PackedScene = load(car_list_global[new_car_name][0])
	var car_instantia: VehicleBody3D = car.instantiate()
	car_instantia.position = spawner.position
	car_instantia.rotate_y(2)
	add_child(car_instantia)
	car_instantia.axis_lock_linear_x = true
	car_instantia.steering = 0.5
	
	padlock()


func _on_right_button_up() -> void:
	for item in get_children():
		if item.get_class() == "VehicleBody3D":
			item.queue_free()
	
	var car_num_hud = int(car_num.text) + 1
	if car_num_hud >= car_names.size():
		car_num_hud = 0
	var new_car_name = car_names[car_num_hud]
	car_name_label.text = new_car_name
	car_num.text = str(car_names.find(new_car_name))
	#print(car_list_global[new_car_name][1]) #precio del vehiculo
	#print(data_loaded.cars_data[new_car_name]) #si esta desponible: true, si no: falsee
	
	if data_loaded.cars_data[new_car_name]:
		select.text = tr("id_17") #seleccionar
	else:
		select.text = tr("id_16") + " $" + str(car_list_global[new_car_name][1])
	
	
	var car: PackedScene = load(car_list_global[new_car_name][0])
	var car_instantia: VehicleBody3D = car.instantiate()
	car_instantia.position = spawner.position
	car_instantia.rotate_y(2)
	add_child(car_instantia)
	car_instantia.axis_lock_linear_x = true
	car_instantia.steering = 0.5
	
	padlock()


func _on_go_back_button_up() -> void:
	get_tree().change_scene_to_file("res://Maps/loby_rework/loby_rework.tscn")


func _on_select_button_up() -> void:
	if select.text.contains(tr("id_16")) and data_loaded.money >= car_list_global[car_name_label.text][1]:
		print("comprando auto")
		data_loaded.money -= car_list_global[car_name_label.text][1]
		select.text = tr("id_17")
		data_loaded.cars_data[car_name_label.text] = true
		global_var.save_data(JSON.stringify(data_loaded))
		
	elif select.text.contains(tr("id_16")) and data_loaded.money < car_list_global[car_name_label.text][1]:
		print("no puedes comprar")
	
	if select.text.contains(tr("id_17")):
		print("seleccionando auto")
		data_loaded.car = car_name_label.text
		global_var.save_data(JSON.stringify(data_loaded))
	
	money_display.reset_money()
	
	padlock()

func padlock():
	if select.text.contains(tr("id_16")):
		padlock_anim.visible = true
	elif select.text.contains(tr("id_17")):
		padlock_anim.visible = false
	
	if padlock_anim.visible != candado_visible_anterior:
		if padlock_anim.visible:
			anim.play("padlock_input")
		else:
			anim.play("padlock_output")
		
	candado_visible_anterior = padlock_anim.visible
