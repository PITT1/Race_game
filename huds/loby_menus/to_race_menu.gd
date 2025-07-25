extends Control

@onready var anim: AnimationPlayer = $AnimationPlayer


func input_anim():
	anim.play("input")
	
func output_anim():
	anim.play("output")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "output":
		queue_free()


func _on_to_f_1_race_button_up() -> void:
	get_tree().change_scene_to_file("res://Maps/circuit_test_2/test_2.tscn")


func _on_to_rc_circuit_button_up() -> void:
	get_tree().change_scene_to_file("res://Maps/rc_circuit/rc_circuit_1.tscn")


func _on_nascar_circuit_button_up() -> void:
	get_tree().change_scene_to_file("res://Maps/nascar_circuit/nascar_circuit.tscn")


func _on_double_circuit_button_up() -> void:
	get_tree().change_scene_to_file("res://Maps/2_vias_circuit_1/pista_doble_1.tscn")


func _on_basic_circuit_button_up() -> void:
	get_tree().change_scene_to_file("res://Maps/basic_circuit_1/basic_circuit_1.tscn")
