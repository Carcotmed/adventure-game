extends Node2D
class_name Weapon

@onready var animation_player: AnimationPlayer = %AnimationPlayer
signal attack_finished

var should_flip: bool = false
@export var parent_sprite: AnimatedSprite2D

var follow_mouse: bool = true

func _process(delta: float) -> void:
	if follow_mouse:
		var angle = get_angle_to(get_global_mouse_position())
		rotate(angle + PI/2)
		should_flip = global_rotation < 0
		parent_sprite.flip_h = should_flip
		z_index = 0 if should_flip else 2

func attack() -> void:
	animation_player.play("slash")
	await animation_player.animation_finished
	animation_player.play("RESET")
	attack_finished.emit()
