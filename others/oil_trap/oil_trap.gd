extends Node3D


func _on_sensor_body_entered(body: VehicleBody3D) -> void:
	if body is VehicleBody3D:
		body.oil_trap_on = true
	else:
		pass


func _on_sensor_body_exited(body: VehicleBody3D) -> void:
	if body is VehicleBody3D:
		body.oil_trap_on = false
	else:
		pass
