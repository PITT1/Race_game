extends VehicleBody3D

@export var MAX_STEER = 0.7
@export var ENGINE_POWER = 1000
@onready var ground_sensor: RayCast3D = $ground_sensor


func _physics_process(delta: float) -> void:
	steering = move_toward(steering, Input.get_axis("ui_right", "ui_left") * MAX_STEER, delta * 10)
	engine_force = Input.get_axis("ui_down", "ui_up") * ENGINE_POWER
	
	air_control(delta)

func air_control(delta):
	if not ground_sensor.is_colliding():
		if Input.is_action_pressed("ui_left"):
			set_angular_velocity(lerp(angular_velocity, Vector3.UP * 5, delta))
		
		if Input.is_action_pressed("ui_right"):
			set_angular_velocity(lerp(angular_velocity, Vector3.DOWN * 5, delta))
			
		if Input.is_action_pressed("ui_up"):
			set_angular_velocity(lerp(angular_velocity, Vector3(0,0,5), delta))
		
		if Input.is_action_pressed("ui_down"):
			set_angular_velocity(lerp(angular_velocity, Vector3(0,0,-5), delta))
