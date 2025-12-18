extends Label
@onready var label: Label = $"."
var data: Dictionary = Options.load_data() 

func _process(delta: float) -> void:
	if delta:
		pass
	if data.view_fps == true:
		label.text = str(Engine.get_frames_per_second())
