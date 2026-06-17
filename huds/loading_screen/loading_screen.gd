extends Control

@onready var label: Label = $CanvasLayer/ColorRect/CenterContainer/VBoxContainer/Label
@onready var progress_bar: ProgressBar = $CanvasLayer/ColorRect/CenterContainer/VBoxContainer/ProgressBar


var target_scene: String = ""
var progress: Array = []

func _ready() -> void:
	ResourceLoader.load_threaded_request(target_scene, "", true)

func _process(delta: float) -> void:
	var status = ResourceLoader.load_threaded_get_status(target_scene, progress)
	
	match status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			progress_bar.value = progress[0] * 100
		
		ResourceLoader.THREAD_LOAD_LOADED:
			progress_bar.value = 100
			var new_scene: PackedScene = ResourceLoader.load_threaded_get(target_scene)
			get_tree().change_scene_to_packed(new_scene)
			queue_free()
		
		ResourceLoader.THREAD_LOAD_FAILED:
			label.text = "ERROR"
			set_process(false)
