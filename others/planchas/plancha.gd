extends Node3D
@onready var anim: AnimationPlayer = $AnimationPlayer
@onready var sensor_collision: CollisionShape3D = $sensor/sensor_collision

func _on_sensor_body_entered(body: Node3D) -> void:
	if body is VehicleBody3D:
		anim.play("smash")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "smash":
		anim.play("reset_sensor")
