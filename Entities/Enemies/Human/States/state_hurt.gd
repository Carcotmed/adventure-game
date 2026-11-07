extends State

@onready var sprite: AnimatedSprite2D = %Sprite
@export var state_idle: State
@export var hit_sound: SoundEffect

func enter() -> void:
	sprite.play("hurt")
	AudioManager.play_sfx_at(hit_sound, parent.global_position)
	sprite.animation_finished.connect(_on_sprite_animation_finished)

func on_physics_process(delta: float) -> void:
	parent.move_and_slide()
	
func _on_sprite_animation_finished() -> void:
	state_manager.change_state(state_idle)
	
func exit() -> void:
	if sprite.animation_finished.is_connected(_on_sprite_animation_finished):
		sprite.animation_finished.disconnect(_on_sprite_animation_finished)
