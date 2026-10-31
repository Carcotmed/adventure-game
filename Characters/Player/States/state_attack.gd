extends State

@export var state_idle: State
@export var weapon: Weapon
@onready var sprite: AnimatedSprite2D = %Sprite

func enter() -> void:
	weapon.attack_finished.connect(on_finish_attach)
	weapon.attack()

func on_finish_attach() -> void:
	weapon.attack_finished.disconnect(on_finish_attach)
	state_manager.change_state(state_idle)
