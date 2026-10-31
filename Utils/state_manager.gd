class_name StateManager
extends Node

@export var initial_state: State
var current_state: State
@export var parent: CharacterBody2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		if child is State:
			child.state_manager = self
			child.parent = parent
			
	change_state(initial_state)
	
func change_state(new_state: State) -> void:
	if current_state != null:
		current_state.exit()
	new_state.enter()
	print(parent.name + " Changing to " + new_state.name)
	current_state = new_state
	
func _input(event: InputEvent) -> void:
	current_state.on_input(event)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	current_state.on_process(delta)

func _physics_process(delta: float) -> void:
	current_state.on_physics_process(delta)
