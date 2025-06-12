extends VehicleBody3D

@export var MAX_STEER = 0.7
@export var ENGINE_POWER = 1500

# Sistema BOT
@export var is_player: bool = true
@export_category("BOT")
@export var dificulty : int = 1
@onready var path_follow = get_parent().get_child(4).get_child(0)
@onready var path = get_parent().get_child(4)
var speed = 5.0 
var target_progress = 0.0

#@export var camera_distance: float = 4
#@export var camera_height: float = 4

#var target_offset = Vector2.ZERO
#var current_offset = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if is_player:
		steering = move_toward(steering, Input.get_axis("ui_right", "ui_left") * MAX_STEER, delta * 10)
		engine_force = Input.get_axis("ui_down", "ui_up") * ENGINE_POWER
	else:
		#ESTO LO HACE SOLO EL BOT
		var distance_to_point = global_position.distance_to(path_follow.global_position)
		if distance_to_point < 30:
			path_follow.progress += 30
			path_follow.h_offset = randf_range(5, -5)
			
		# Calcular dirección hacia el siguiente puntovar 
		var direction_to_target = path_follow.global_transform.origin - global_transform.origin
		direction_to_target.y = 0
		direction_to_target = direction_to_target.normalized()
		
		#calculando angulo
		var current_forward = global_transform.basis.z
		var angle_to_target = atan2(direction_to_target.x, direction_to_target.z)
		var current_angle = atan2(current_forward.x, current_forward.z)
		
		# Calcular ángulo relativo al vehículo
		var relative_angle = wrapf(angle_to_target - current_angle, -PI, PI)
		
		#limite al angulo relativo
		relative_angle = clamp(relative_angle, -MAX_STEER, MAX_STEER)
		
		
		steering = relative_angle
		
		if dificulty == 1:
			engine_force = ENGINE_POWER / 1.5
		elif dificulty == 2:
			engine_force = ENGINE_POWER
		elif dificulty == 3:
			engine_force = ENGINE_POWER * 1.1
		
		
		

#func update_pcam():
#	var forward_direction = -global_transform.basis.z.normalized()
#	target_offset = Vector2(forward_direction.x * camera_distance, forward_direction.z * camera_distance)
#	current_offset = current_offset.lerp(target_offset, 0.05)
#	var pCam = get_parent().get_child(3) 
#	if pCam.name == "PhantomCamera3D":
#		pCam.follow_offset = Vector3(current_offset.x, camera_height, current_offset.y)
#	else:
#		print("no se encontro phanton camera")
