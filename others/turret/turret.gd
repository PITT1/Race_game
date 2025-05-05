extends RigidBody3D
@onready var turret_gun: MeshInstance3D = $TurretGun

var target = null

func _physics_process(delta: float) -> void:
	if target != null:
		var direction = target.global_position - turret_gun.global_position
		turret_gun.look_at(turret_gun.global_position + -direction, Vector3.UP)
	
	if delta:
		pass

func _on_sensor_body_entered(body: Node3D) -> void:
	target = body


func _on_sensor_body_exited(body: Node3D) -> void:
	target = null
	
	if body:
		pass
