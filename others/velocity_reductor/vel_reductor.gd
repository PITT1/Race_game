extends Area3D

@export var velocity_reduction: float = 30


func _on_body_entered(body: Node3D) -> void:
	if body.get_class() == "VehicleBody3D" and body.name.contains("Bot"):
		body.vel_reduction = velocity_reduction


func _on_body_exited(body: Node3D) -> void:
	if body.get_class() == "VehicleBody3D" and body.name.contains("Bot"):
		body.vel_reduction = 0
