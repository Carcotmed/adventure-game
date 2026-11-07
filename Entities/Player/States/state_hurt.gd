extends State

@onready var sprite: AnimatedSprite2D = %Sprite
@export var state_idle: State

func enter() -> void:
	sprite.play("hurt")
	sprite.animation_finished.connect(_on_sprite_animation_finished)

func on_physics_process(delta: float) -> void:
	parent.move_and_slide()
	
func _on_sprite_animation_finished() -> void:
	state_manager.change_state(state_idle)
	sprite.animation_finished.disconnect(_on_sprite_animation_finished)
