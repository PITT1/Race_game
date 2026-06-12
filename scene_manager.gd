extends Node

const LOADING_SCREEN = "res://huds/loading_screen/loading_screen.tscn"

func load_scene(target_path: String):
	var loading_screen = load(LOADING_SCREEN).instantiate()
	loading_screen.target_scene = target_path
	get_tree().root.add_child(loading_screen)
	
