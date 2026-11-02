class_name InventoryComponent
extends Node

signal slot_changed(slot_number: int)

@export var inventory_slots: int = 20

var inventory: Array[ItemSlot] = []

func _ready() -> void:
	inventory.resize(inventory_slots)

func add_item(item: ItemSlot) -> ItemSlot:
	var remaining := item.quantity
	var max_stack := maxi(1, item.item_data.max_stack)

	# Pass 1: top up existing partial stacks of the same item.
	for i in inventory_slots:
		if remaining <= 0:
			break
		var slot := inventory[i]
		if slot == null or slot.item_data != item.item_data or slot.quantity >= max_stack:
			continue
		var added := mini(remaining, max_stack - slot.quantity)
		slot.quantity += added
		remaining -= added
		slot_changed.emit(i)

	# Pass 2: use empty slots.
	for i in inventory_slots:
		if remaining <= 0:
			break
		if inventory[i] != null:
			continue
		var new_slot := ItemSlot.new(item.item_data, mini(remaining, max_stack))
		inventory[i] = new_slot
		remaining -= new_slot.quantity
		slot_changed.emit(i)

	if remaining <= 0:
		return null
	var leftover := ItemSlot.new(item.item_data, remaining)
	return leftover
	
func swap_item(index: int, item: ItemSlot = null) -> ItemSlot:
	if index < 0 or index >= inventory_slots:
		push_warning("swap_item: invalid index %d" % index)
		return item

	if item != null and (item.item_data == null or item.quantity <= 0):
		item = null

	var previous_item := inventory[index]
	inventory[index] = item
	slot_changed.emit(index)
	return previous_item
