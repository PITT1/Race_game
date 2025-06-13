extends Node3D

@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	anim.play("idle")


func _on_area_3d_body_entered(body: Node3D) -> void:
	print("pantalla de seleccion de carrera")


func _on_area_3d_body_exited(body: Node3D) -> void:
	print("salir de la pantalla")
