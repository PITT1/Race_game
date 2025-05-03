extends VehicleBody3D

@export var MAX_STEER = 0.7
@export var ENGINE_POWER = 1000
@onready var ground_sensor: RayCast3D = $ground_sensor

@onready var wheel_1: VehicleWheel3D = $wheel_1
@onready var wheel_2: VehicleWheel3D = $wheel_2
@onready var wheel_3: VehicleWheel3D = $wheel_3
@onready var wheel_4: VehicleWheel3D = $wheel_4

@onready var timer_oil_trap: Timer = $Timer_oil_trap
var oil_trap_on = false


func _physics_process(delta: float) -> void:
	steering = move_toward(steering, Input.get_axis("ui_right", "ui_left") * MAX_STEER, delta * 10)
	engine_force = Input.get_axis("ui_down", "ui_up") * ENGINE_POWER
	
	air_control(delta)
	
	if oil_trap_on:
		on_oil_trap()

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

func on_oil_trap():
	timer_oil_trap.start()
	wheel_1.set_friction_slip(0.5)
	wheel_2.set_friction_slip(0.5)
	wheel_3.set_friction_slip(0.5)
	wheel_4.set_friction_slip(0.5)


func _on_timer_oil_trap_timeout() -> void:
	wheel_1.set_friction_slip(5)
	wheel_2.set_friction_slip(5)
	wheel_3.set_friction_slip(5)
	wheel_4.set_friction_slip(5)
