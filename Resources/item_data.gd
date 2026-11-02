class_name ItemData
extends Resource

enum ItemType {
	Material, Key, Consumable, Equipment
}

enum ItemRarity {
	Common, Unusual, Rare, Epic, Legendary
}

@export var sprite_frames: SpriteFrames
@export var name: String
@export_multiline("Item Description") var description: String
@export var max_stack: int = 99
@export var item_type: ItemType
@export var rarity: ItemRarity
@export var pickup_sound: SoundEffect
