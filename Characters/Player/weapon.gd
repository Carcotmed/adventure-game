extends Node2D
class_name Weapon

@onready var animation_player: AnimationPlayer = %AnimationPlayer
signal attacking
signal attack_finished

func attack() -> void:
	attacking.emit()
	animation_player.play("slash")
	await animation_player.animation_finished
	animation_player.play("RESET")
	attack_finished.emit()
