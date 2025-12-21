extends Control
@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	anim.play("input")

func _exit_tree() -> void:
	get_tree().paused = false

func _on_continue_btn_button_up() -> void:
	anim.play("output")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "output":
		queue_free()


func _on_reboot_race_btn_button_up() -> void:
	Ads._load_interstitial_ad()
	get_tree().reload_current_scene()


func _on_go_to_main_menu_btn_button_up() -> void:
	Ads._show_interstitial_ad()
	get_tree().change_scene_to_file("res://Maps/loby_1/loby_1.tscn")
