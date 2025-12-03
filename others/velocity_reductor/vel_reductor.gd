extends Area3D

@export var velocity_reduction: float = 30


func _on_body_entered(body: Node3D) -> void:
	if body.get_class() == "vehicleBody3D" and body.name.contains("BOT"):
		body.vel_reduction = velocity_reduction
