extends Control
@onready var position_label: Label = $CanvasLayer/position_label

var car: VehicleBody3D = null
@onready var race_list: Array = []
var label_text: String = ""

func _ready() -> void:
	car = get_parent()

func _physics_process(delta: float) -> void:
	if delta:
		pass
	if get_parent().get_parent().is_race == true:
		race_list = get_parent().get_parent().race_order
		
		for i in race_list.size():
			if race_list[i] == car:
				label_text = "pos: " + str(i + 1)
				position_label.set_text(label_text)
	else:
		position_label.visible = false
