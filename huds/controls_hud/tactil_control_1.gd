extends Control
@onready var brake_reverse: TouchScreenButton = $CanvasLayer/AspectRatioContainer/brake_reverse
@onready var acelerate: TouchScreenButton = $CanvasLayer/AspectRatioContainer/acelerate
@onready var left: TouchScreenButton = $CanvasLayer/AspectRatioContainer/left
@onready var right: TouchScreenButton = $CanvasLayer/AspectRatioContainer/right


var color_presed = Color(1, 1, 1, 0.60)
var color_release = Color(1, 1, 1, 0.39)

func _on_brake_reverse_pressed() -> void:
	brake_reverse.modulate = color_presed


func _on_brake_reverse_released() -> void:
	brake_reverse.modulate = color_release


func _on_acelerate_pressed() -> void:
	acelerate.modulate = color_presed


func _on_acelerate_released() -> void:
	acelerate.modulate = color_release


func _on_left_pressed() -> void:
	left.modulate = color_presed


func _on_left_released() -> void:
	left.modulate = color_release


func _on_right_pressed() -> void:
	right.modulate = color_presed


func _on_right_released() -> void:
	right.modulate = color_release
