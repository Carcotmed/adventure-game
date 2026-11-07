extends State

@export var state_idle: State
@export var weapon: Weapon
@export var sword_sound: SoundEffect
@onready var sprite: AnimatedSprite2D = %Sprite

func enter() -> void:
	weapon.attack_finished.connect(on_finish_attach)
	AudioManager.play_sfx_at(sword_sound, parent.global_position)
	weapon.attack()

func on_finish_attach() -> void:
	weapon.attack_finished.disconnect(on_finish_attach)
	state_manager.change_state(state_idle)
