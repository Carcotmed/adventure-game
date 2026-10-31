class_name HandPivot
extends Marker2D

var should_flip: bool = false
@onready var sprite: AnimatedSprite2D = %Sprite

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	var angle = get_angle_to(get_global_mouse_position())
	rotate(angle + PI/2)
	should_flip = global_rotation < 0
	sprite.flip_h = should_flip
	z_index = 0 if should_flip else 2
