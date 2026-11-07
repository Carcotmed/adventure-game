class_name Pickup
extends Node2D

@export var item_data: ItemData
@export var quantity: int = 1

@onready var sprite: AnimatedSprite2D = %Sprite
@onready var pickup_area: Area2D = $PickupArea

var _collected := false
var _waiting_body: Node2D = null
var _waiting_inventory: InventoryComponent = null

func _ready() -> void:
	if item_data == null:
		push_warning("Pickup without item_data: %s" % get_path())
		queue_free()
		return
	sprite.sprite_frames = item_data.sprite_frames
	sprite.play()
	pickup_area.body_entered.connect(_on_pickup_area_body_entered)
	pickup_area.body_exited.connect(_on_pickup_area_body_exited)

func _on_pickup_area_body_entered(body: Node2D) -> void:
	if _collected:
		return
	var inventory := body.get("inventory_component") as InventoryComponent
	if inventory == null:
		return
	_try_pickup(body, inventory)

func _on_pickup_area_body_exited(body: Node2D) -> void:
	if body == _waiting_body:
		_stop_waiting()

func _try_pickup(body: Node2D, inventory: InventoryComponent) -> void:
	var leftover := inventory.add_item(ItemSlot.new(item_data, quantity))
	if leftover == null:
		_collect()
		return
	quantity = leftover.quantity
	_wait_for_space(body, inventory)

func _collect() -> void:
	if _collected:
		return
	_collected = true
	_stop_waiting()
	pickup_area.set_deferred("monitoring", false)
	AudioManager.play_sfx_at(item_data.pickup_sound, global_position)
	queue_free()

func _wait_for_space(body: Node2D, inventory: InventoryComponent) -> void:
	_stop_waiting()
	_waiting_body = body
	_waiting_inventory = inventory
	inventory.slot_changed.connect(_on_inventory_changed)

func _stop_waiting() -> void:
	if is_instance_valid(_waiting_inventory) and _waiting_inventory.slot_changed.is_connected(_on_inventory_changed):
		_waiting_inventory.slot_changed.disconnect(_on_inventory_changed)
	_waiting_inventory = null
	_waiting_body = null

func _on_inventory_changed(_index: int) -> void:
	# Deferred: slot_changed fires in the middle of the inventory's own operation.
	_retry_pickup.call_deferred()

func _retry_pickup() -> void:
	if _collected or not is_instance_valid(_waiting_body) or not is_instance_valid(_waiting_inventory):
		return
	if pickup_area.overlaps_body(_waiting_body):
		_try_pickup(_waiting_body, _waiting_inventory)
