extends Node

const SAVE_OPTIONS_PATH: String = "user://options.dat"

var options_file_canvas: Dictionary = {
	language = "default",
	music = true,
	music_volume = 0.7,
	view_fps = false
}

func init_save_options_canvas():
	if not FileAccess.file_exists(SAVE_OPTIONS_PATH):
		var file = FileAccess.open(SAVE_OPTIONS_PATH, FileAccess.WRITE)
		file.store_string(JSON.stringify(options_file_canvas))
		file.close()
		print("archivo de opciones guardado por primera vez")
	else:
		print("el archivo de opciones ya existe")
	
	var data: Dictionary = load_data()
	if options_file_canvas.size() != data.size():
		data.merge(options_file_canvas)
		save_data(data)
		print("actualizando el option file canvas")

func save_data(content: Dictionary):
	var file = FileAccess.open(SAVE_OPTIONS_PATH, FileAccess.WRITE)
	file.store_string(JSON.stringify(content))
	file.close()

func load_data():
	if FileAccess.file_exists(SAVE_OPTIONS_PATH):
		var file = FileAccess.open(SAVE_OPTIONS_PATH, FileAccess.READ)
		var content = file.get_as_text()
		file.close()
		return JSON.parse_string(content)
	else:
		var file = FileAccess.open(SAVE_OPTIONS_PATH, FileAccess.WRITE)
		file.store_string(JSON.stringify(options_file_canvas))
		file.close()
		file = FileAccess.open(SAVE_OPTIONS_PATH, FileAccess.READ)
		var content = file.get_as_text()
		file.close()
		return JSON.parse_string(content)
