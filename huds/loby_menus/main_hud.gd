extends Control
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var pop_sound: AudioStreamPlayer = $AudioStreamPlayer

var global_var = load("res://global_var.gd").new()
var track_list: Dictionary = {}
var selector: int = 1
@onready var track_name: Label = $CanvasLayer/race_selector/HBoxContainer/VBoxContainer/track_name
@onready var left_btn: Button = $CanvasLayer/race_selector/HBoxContainer/left_btn
@onready var right_btn: Button = $CanvasLayer/race_selector/HBoxContainer/right_btn
@onready var image_track: TextureRect = $CanvasLayer/race_selector/HBoxContainer/VBoxContainer/image_track
@onready var bg_volume_range: HSlider = $CanvasLayer/options_page/VBoxContainer/bg_volume_range
@onready var bg_music_button: CheckButton = $CanvasLayer/options_page/VBoxContainer/bg_music_button
@onready var set_spanish_button: Button = $CanvasLayer/options_page/VBoxContainer/MarginContainer2/VBoxContainer/HBoxContainer/set_spanish_button
@onready var set_english_button: Button = $CanvasLayer/options_page/VBoxContainer/MarginContainer2/VBoxContainer/HBoxContainer/set_english_button
var lang_selected: String = ""

var options_file: Dictionary = {}

func _ready() -> void:
	track_list = global_var.track_list
	track_name.text = track_list[selector][0] 
	image_track.set_texture(load(track_list[selector][2]))
	
	#options
	options_file = Options.load_data()
	bg_music_button.button_pressed = options_file.music
	bg_volume_range.value = options_file.music_volume
	
	#options_languages
	if lang_selected == "default":
		lang_selected = TranslationServer.get_locale()
		if lang_selected == "es":
			set_spanish_button.disabled = true
			set_english_button.disabled = false
		elif lang_selected == "en":
			set_spanish_button.disabled = false
			set_english_button.disabled = true
	else:
		TranslationServer.set_locale(options_file.language)
		if TranslationServer.get_locale() == "es":
			set_spanish_button.disabled = true
			set_english_button.disabled = false
		elif TranslationServer.get_locale() == "en":
			set_spanish_button.disabled = false
			set_english_button.disabled = true

func _on_quit_btn_button_up() -> void:
	pop_sound.play()
	get_tree().quit()


func _on_play_btn_button_up() -> void:
	pop_sound.play()
	anim.play("to_page_2")
	

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "to_practice":
		pop_sound.play()
		queue_free()

func _on_back_btn_button_up() -> void:
	pop_sound.play()
	anim.play("to_page_1")


func _on_right_btn_button_up() -> void:
	pop_sound.play()
	selector += 1
	if selector > track_list.size():
		selector = track_list.size()
	track_name.text = track_list[selector][0]
	image_track.set_texture(load(track_list[selector][2]))
	

func _on_left_btn_button_up() -> void:
	pop_sound.play()
	selector -= 1
	if selector < 1:
		selector = 1
	track_name.text = track_list[selector][0]
	image_track.set_texture(load(track_list[selector][2]))


func _on_to_race_button_up() -> void:
	pop_sound.play()
	get_tree().change_scene_to_file(track_list[selector][1])


func _on_quick_race_btn_button_up() -> void:
	pop_sound.play()
	anim.play("to_quick_race")


func _on_button_button_up() -> void:
	pop_sound.play()
	get_tree().change_scene_to_file("res://huds/car_selection/car_selection.tscn")


func _on_options_btn_button_up() -> void:
	pop_sound.play()
	anim.play("to_menu_options")


func _on_save_and_back_options_btn_button_up() -> void:
	Options.save_data(options_file)
	pop_sound.play()
	anim.play("exit_menu_options")


func _on_bg_music_button_toggled(toggled_on: bool) -> void:
	pop_sound.play()
	if toggled_on:
		options_file.music = true
		BgMusicManager.select_random_music()
		BgMusicManager.play()
	else:
		options_file.music = false
		BgMusicManager.stop()


func _on_bg_volume_range_drag_ended(value_changed: bool) -> void:
	if value_changed:
		BgMusicManager.set_volume_linear(bg_volume_range.value)
		options_file.music_volume = bg_volume_range.value


func _on_set_spanish_button_button_up() -> void:
	TranslationServer.set_locale("es")
	set_english_button.disabled = false
	set_spanish_button.disabled = true
	options_file.language = "es"
	Options.save_data(options_file)
	print(options_file)


func _on_set_english_button_button_up() -> void:
	TranslationServer.set_locale("en")
	set_english_button.disabled = true
	set_spanish_button.disabled = false
	options_file.language = "en"
	Options.save_data(options_file)
	print(options_file)


func _on_to_back_menu_button_up() -> void:
	pop_sound.play()
	anim.play("back_to_page_2_from_race_selector")
