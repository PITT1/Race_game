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
	thunderbolt = "res://Cars/thunderbolt/thunderbolt.tscn",
	pinkinator = "res://Cars/pinkinator/pinkinator.tscn",
	f1_70s = "res://Cars/f1_70s/f1_70s.tscn",
	montana = "res://Cars/montana/montana.tscn",
	monster = "res://Cars/monster/monster.tscn",
	z40 = "res://Cars/z40/z40.tscn",
	toreto = "res://Cars/toreto/toreto.tscn",
	nomad = "res://Cars/nomad/nomad.tscn"
}

var bot_list = {
	hotrod1_BOT = "res://Cars/hot_rod_1/hot_rod_1_BOT.tscn",
	sentinel_gt_BOT = "res://Cars/sentinel_gt/sentinel_gt_BOT.tscn",
	empaler_truck_BOT = "res://Cars/empaler_truck/empaler_truck_BOT.tscn",
	raven_356_BOT = "res://Cars/raven_356/raven_356_BOT.tscn",
	racing_rod_BOT = "res://Cars/racing_rod/racing_rod_BOT.tscn",
	blade_rod_BOT = "res://Cars/blade_rod/blade_rod_BOT.tscn",
	thunderbolt_BOT = "res://Cars/thunderbolt/thunderbolt_BOT.tscn",
	bugrod_BOT = "res://Cars/rat_rod/bug_rod_BOT.tscn",
	pinkinator_BOT = "res://Cars/pinkinator/pinkinator_BOT.tscn",
	f1_70s_BOT = "res://Cars/f1_70s/f1_70s_BOT.tscn",
	montana_BOT = "res://Cars/montana/montana_BOT.tscn",
	monster_BOT = "res://Cars/monster/monster_BOT.tscn",
	z40_BOT = "res://Cars/z40/z40_BOT.tscn",
	toreto_BOT = "res://Cars/toreto/toreto_BOT.tscn",
	nomad_BOT = "res://Cars/nomad/nomad_BOT.tscn"
}
#nobre de la pista, direccion de la pista, si esta desbloqueada o no
var track_list = {
	1 : ["track_1", "res://Maps/circuit_test_2/test_2.tscn", false],
	2 : ["track_2", "res://Maps/rc_circuit/rc_circuit_1.tscn", false],
	3 : ["track_3", "res://Maps/nascar_circuit/nascar_circuit.tscn", false],
	4 : ["track_4", "res://Maps/basic_circuit_1/basic_circuit_1.tscn", false],
	5 : ["track_5", "res://Maps/2_vias_circuit_1/pista_doble_1.tscn", false]
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

func init_save_game():
	if not FileAccess.file_exists(SAVE_GAME_PATH):
		var file = FileAccess.open(SAVE_GAME_PATH, FileAccess.WRITE)
		file.store_string(JSON.stringify(player_canvas))
		file.close()
		print("archivo guardado por primera vez")
	else:
		print("el archivo de guardado ya existe")
