extends Control
@onready var anim: AnimationPlayer = $AnimationPlayer

func input_anim():
	anim.play("input")
	
func output_anim():
	anim.play("output")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "output":
		queue_free()


func _on_go_to_garage_button_up() -> void:
	get_tree().change_scene_to_file("res://huds/car_selection/car_selection.tscn")
