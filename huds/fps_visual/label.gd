extends Label
@onready var label: Label = $"."

func _process(delta: float) -> void:
	label.text = str(Engine.get_frames_per_second())
