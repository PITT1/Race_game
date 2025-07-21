extends Control
@onready var anim: AnimationPlayer = $AnimationPlayer


func _on_quit_btn_button_up() -> void:
	get_tree().quit()


func _on_play_btn_button_up() -> void:
	anim.play("to_page_2")
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "to_practice":
		queue_free()


func _on_practice_btn_button_up() -> void:
	get_parent().on_play = true
	get_parent().pCam.priority = 2
	anim.play("to_practice")


func _on_back_btn_button_up() -> void:
	anim.play("to_page_1")
