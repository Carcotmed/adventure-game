class_name ItemSlot
extends RefCounted

var item_data: ItemData
var quantity: int

func _init(p_item_data: ItemData = null, p_quantity: int = 0) -> void:
	self.item_data = p_item_data
	self.quantity = p_quantity
	
