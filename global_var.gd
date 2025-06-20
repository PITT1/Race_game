extends Node

const SAVE_GAME_PATH: String = "user://save_game1.dat"

var car_list = {
	bugrod = "res://Cars/rat_rod/bug_rod.tscn",
	hotrod1 = "res://Cars/hot_rod_1/hot_rod_1.tscn",
	sentinel_gt = "res://Cars/sentinel_gt/sentinel_gt.tscn",
	empaler_truck = "res://Cars/empaler_truck/empaler_truck.tscn",
	raven_356 = "res://Cars/raven_356/raven_356.tscn",
	racing_rod = "res://Cars/racing_rod/racing_rod.tscn",
	blade_rod = "res://Cars/blade_rod/blade_rod.tscn",
	thunderbolt = "res://Cars/thunderbolt/thunderbolt.tscn"
} 
	
	
var player_canvas = {
	money = 0,
	car = "bugrod"
}

func init_save_canvas():
	if not FileAccess.file_exists(SAVE_GAME_PATH):
		var file = FileAccess.open(SAVE_GAME_PATH, FileAccess.WRITE)
		file.store_string(JSON.stringify(player_canvas))
		file.close()
		print("archivo guardado por primera vez")
	else:
		print("el archivo de guardado ya existe")

func save_data(content: String):
	var file = FileAccess.open(SAVE_GAME_PATH, FileAccess.WRITE)
	file.store_string(content)
	file.close()

func load_data():
	var file = FileAccess.open(SAVE_GAME_PATH, FileAccess.READ)
	var content = file.get_as_text()
	file.close()
	return content
