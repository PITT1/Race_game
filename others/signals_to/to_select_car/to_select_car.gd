extends Node3D
@onready var anim: AnimationPlayer = $AnimationPlayer
@export var to_select_car_hud: PackedScene

func _ready() -> void:
	anim.play("idle")


func _on_sensor_body_entered(body: Node3D) -> void:
	var instantia = to_select_car_hud.instantiate()
	add_child(instantia)
	instantia.input_anim()


func _on_sensor_body_exited(body: Node3D) -> void:
	get_child(3).output_anim()
