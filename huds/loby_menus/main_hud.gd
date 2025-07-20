extends Control
@onready var anim: AnimationPlayer = $AnimationPlayer


func _on_quit_btn_button_up() -> void:
	get_tree().quit()


func _on_play_btn_button_up() -> void:
	get_parent().on_play = true
	get_parent().pCam.priority = 2
	anim.play("out")
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "out":
		queue_free()
