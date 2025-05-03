extends RigidBody3D

@onready var particles: CPUParticles3D = $particles
@onready var fire: CPUParticles3D = $fire
@onready var smoke: CPUParticles3D = $smoke

@onready var caja_1: Node3D = $caja_1

@onready var timer: Timer = $Timer
var count = 0

func _physics_process(delta: float) -> void:
	var speed = linear_velocity.length()
	if speed > 10 and count == 0:
		collision_layer = 0
		collision_mask = 0
		timer.start()
		caja_1.visible = false
		fire.emitting = true
		particles.emitting = true
		smoke.emitting = true
		count = count + 1


func _on_timer_timeout() -> void:
	queue_free()
