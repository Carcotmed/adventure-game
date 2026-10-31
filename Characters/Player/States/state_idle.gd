extends State

@export var state_walk: State
@export var state_attack: State
@onready var sprite: AnimatedSprite2D = %Sprite

func enter() -> void:
	sprite.play("idle")

func on_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("attack"):
		state_manager.change_state(state_attack)
		

func on_physics_process(delta: float) -> void:
	if Input.get_axis("up", "down") || Input.get_axis("left", "right"):
		state_manager.change_state(state_walk)
