extends Control
@onready var anim: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	anim.play("countdown")


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "countdown":
		await get_tree().create_timer(1).timeout
		queue_free()
