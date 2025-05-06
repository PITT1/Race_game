extends RigidBody3D
@onready var turret_gun: MeshInstance3D = $TurretGun
@onready var anim: AnimationPlayer = $AnimationPlayer

@export var projectile_velocity = 1000
@export var projectile: PackedScene
@onready var fire_interval: Timer = $fire_interval

var target = null

func _ready() -> void:
	anim.play("idle")
	target = null

func _physics_process(delta: float) -> void:
	if target != null:
		var direction = target.global_position - turret_gun.global_position
		turret_gun.look_at(turret_gun.global_position + -direction)
		if target.name == "Turret":
			target = null
	

func _on_sensor_body_entered(body: Node3D) -> void:
	anim.pause()
	target = body
	fire_interval.start()


func _on_sensor_body_exited(body: Node3D) -> void:
	anim.play("idle")
	target = null
	
	if body:
		pass

func _on_fire_interval_timeout() -> void:
	on_fire()
	if target == null:
		pass
	else:
		fire_interval.start()

func on_fire():
	var instantia_projectile = projectile.instantiate()
	instantia_projectile.position = turret_gun.global_position + turret_gun.transform.basis.z + Vector3(0, 2, 0)
	instantia_projectile.set_linear_velocity(turret_gun.transform.basis.z * 60)
	add_sibling(instantia_projectile)
