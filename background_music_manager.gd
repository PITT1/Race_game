extends AudioStreamPlayer

const BURNING_ASPHALT = preload("res://sounds/background music/Burning-Asphalt.ogg")
const FULL_THROTTLE_BURN = preload("res://sounds/background music/Full-Throttle-Burn.ogg")
const FULL_THROTTLE_BURN_2 = preload("res://sounds/background music/Full-Throttle-Burn_2.ogg")

var music_list: Array = [BURNING_ASPHALT, FULL_THROTTLE_BURN, FULL_THROTTLE_BURN_2]
var current_track_index = 0

func _ready() -> void:
	stream = BURNING_ASPHALT

func select_random_music():
	var next_track = current_track_index
	while next_track == current_track_index:
		next_track = randi() % len(music_list)
	
	current_track_index = next_track
	stream = music_list[current_track_index]

func set_bg_volume(vol: float):
	set_volume_linear(vol)

func put_bg_music():
	play()
