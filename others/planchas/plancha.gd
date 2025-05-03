extends Node3D

var smash: bool = false

@onready var plancha_l: RigidBody3D = $plancha_L
@onready var plancha_r: RigidBody3D = $plancha_R


func _physics_process(delta: float) -> void:
	if smash:
		plancha_l.linear_velocity.z = -5
		plancha_r.linear_velocity.z = 5
		print("hola")

func _on_sensor_body_entered(body: Node3D) -> void:
	if body is VehicleBody3D:
		smash = true
		print("aplasta")
