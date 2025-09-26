extends Control
@onready var anim: AnimationPlayer = $AnimationPlayer
var global_var = load("res://global_var.gd").new()
var track_list: Dictionary = {}
var selector: int = 1
@onready var track_name: Label = $CanvasLayer/race_selector/VBoxContainer/track_name
@onready var left_btn: Button = $CanvasLayer/race_selector/left_btn
@onready var right_btn: Button = $CanvasLayer/race_selector/right_btn
@onready var image_track: TextureRect = $CanvasLayer/race_selector/VBoxContainer/image_track

func _ready() -> void:
	track_list = global_var.track_list
	track_name.text = track_list[selector][0] 
	image_track.set_texture(load(track_list[selector][2]))


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


func _on_right_btn_button_up() -> void:
	selector += 1
	if selector > track_list.size():
		selector = track_list.size()
	track_name.text = track_list[selector][0]
	image_track.set_texture(load(track_list[selector][2]))
	

func _on_left_btn_button_up() -> void:
	selector -= 1
	if selector < 1:
		selector = 1
	track_name.text = track_list[selector][0]
	image_track.set_texture(load(track_list[selector][2]))


func _on_to_race_button_up() -> void:
	get_tree().change_scene_to_file(track_list[selector][1])


func _on_quick_race_btn_button_up() -> void:
	anim.play("to_quick_race")


func _on_button_button_up() -> void:
	get_tree().change_scene_to_file("res://huds/car_selection/car_selection.tscn")


func _on_options_btn_button_up() -> void:
	anim.play("to_menu_options")


func _on_save_and_back_options_btn_button_up() -> void:
	anim.play("exit_menu_options")
