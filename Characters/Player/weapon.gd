extends Node2D
class_name Weapon

@onready var animation_player: AnimationPlayer = %AnimationPlayer
signal attack_finished


func attack() -> void:
	animation_player.play("slash")
	await animation_player.animation_finished
	animation_player.play("RESET")
	attack_finished.emit()
