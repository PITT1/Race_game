extends Node

const SAVE_GAME_PATH: String = "user://save_game1.dat"


var car_list = { #direccion y precio en tienda
	bugrod = ["res://Cars/rat_rod/bug_rod.tscn", 5000],
	hotrod1 = ["res://Cars/hot_rod_1/hot_rod_1.tscn", 10000],
	sentinel_gt = ["res://Cars/sentinel_gt/sentinel_gt.tscn", 12000],
	empaler_truck = ["res://Cars/empaler_truck/empaler_truck.tscn", 10000],
	raven_356 = ["res://Cars/raven_356/raven_356.tscn", 15000],
	racing_rod = ["res://Cars/racing_rod/racing_rod.tscn", 13000],
	blade_rod = ["res://Cars/blade_rod/blade_rod.tscn", 20000],
	thunderbolt = ["res://Cars/thunderbolt/thunderbolt.tscn", 18000],
	pinkinator = ["res://Cars/pinkinator/pinkinator.tscn", 17000],
	f1_70s = ["res://Cars/f1_70s/f1_70s.tscn", 30000],
	montana = ["res://Cars/montana/montana.tscn", 15000],
	monster = ["res://Cars/monster/monster.tscn", 10000],
	z40 = ["res://Cars/z40/z40.tscn", 25000],
	toreto = ["res://Cars/toreto/toreto.tscn", 28000],
	nomad = ["res://Cars/nomad/nomad.tscn", 20000],
	coutach = ["res://Cars/coutach/coutach.tscn", 40000],
	p_917k = ["res://Cars/p_917K/917k.tscn", 35000],
	spyder = ["res://Cars/spyder/spyder.tscn", 50000],
	vision_gt = ["res://Cars/vision_gt/vision_gt.tscn", 80000],
	mcallen = ["res://Cars/mcallen/mcallen.tscn", 70000]
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
	nomad_BOT = "res://Cars/nomad/nomad_BOT.tscn",
	coutach_BOT = "res://Cars/coutach/coutach_BOT.tscn",
	p_917k_BOT = "res://Cars/p_917K/p_917k_BOT.tscn",
	spyder = "res://Cars/spyder/spyder_BOT.tscn",
	vision_gt_BOT = "res://Cars/vision_gt/vision_gt_BOT.tscn"
}
#nobre de la pista, direccion de la pista, imagen de la pista, si esta desbloqueado o no
var track_list = {
	1 : ["track_1", "res://Maps/circuit_test_2/test_2.tscn", "res://Maps/circuit_test_2/pista_1_selection_menu.png"],
	2 : ["track_2", "res://Maps/rc_circuit/rc_circuit_1.tscn", "res://Maps/rc_circuit/pista_rc_1_selection_menu.png"],
	3 : ["track_3", "res://Maps/nascar_circuit/nascar_circuit.tscn", "res://Maps/nascar_circuit/pista_nascar_circuit_1_selection_menu.png"],
	4 : ["Floating 1", "res://Maps/basic_circuit_1/basic_circuit_1.tscn", "res://Maps/basic_circuit_1/pista_basic_circuit_1_selection_menu.png"],
	5 : ["Floating 2", "res://Maps/2_vias_circuit_1/pista_doble_1.tscn", "res://Maps/2_vias_circuit_1/pista_doble_seleccion_menu.png"],
	6 : ["track_4", "res://Maps/track_2/pista_2.tscn", "res://Maps/track_2/pista_2_selection_menu.png"],
	7 : ["Floating 3", "res://Maps/floating_track_3/floating_track_3.tscn", "res://Maps/floating_track_3/floating_track_3_selection_menu.png"]
}
	
	
var player_canvas = {
	money = 10000,
	car = "bugrod",
	tracks_data = { #pista bloqueada??, mejor tiempo al competir
		1 : [true, "00:00:00"],
		2 : [false, "00:00:00"],
		3 : [false, "00:00:00"],
		4 : [false, "00:00:00"],
		5 : [false, "00:00:00"],
		6 : [false, "00:00:00"],
		7 : [false, "00:00:00"]
	},
	cars_data = { #en true: estn disponibles, en false: estan bloqueados
		bugrod = true,
		hotrod1 = false,
		sentinel_gt = false,
		empaler_truck = false,
		raven_356 = false,
		racing_rod = false,
		blade_rod = false,
		thunderbolt = false,
		pinkinator = false,
		f1_70s = false,
		montana = false,
		monster = false,
		z40 = false,
		toreto = false,
		nomad = false,
		coutach = false,
		p_917k = false,
		spyder = false,
		vision_gt = false,
		mcallen = false
	},
}

func init_save_canvas():
	if not FileAccess.file_exists(SAVE_GAME_PATH):
		var file = FileAccess.open(SAVE_GAME_PATH, FileAccess.WRITE)
		file.store_string(JSON.stringify(player_canvas))
		file.close()
		print("archivo guardado por primera vez")
	else:
		print("el archivo de guardado ya existe")
	
	var saved_content = JSON.parse_string(load_data())
	
	if player_canvas.size() != saved_content.size() or player_canvas.cars_data.size() != saved_content.cars_data.size() or player_canvas.tracks_data.size() != saved_content.tracks_data.size():
		var hola = (JSON.stringify(saved_content.merged(player_canvas)))
		print(hola)
		save_data(hola)
		print("se hizo merge en el save_game_path")

func save_data(content: String):
	var file = FileAccess.open(SAVE_GAME_PATH, FileAccess.WRITE)
	file.store_string(content)
	file.close()

func load_data():
	if not FileAccess.file_exists(SAVE_GAME_PATH):
		init_save_canvas()
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
