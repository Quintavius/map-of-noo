extends Node
class_name ItemProperties

enum ItemType{
	Weapon,
	Attire,
	Accessory,
	Trap,
	Consumable,
	Treasure
}

const ItemSubtypes : Dictionary = {
	ItemType.Weapon : ["Sword"],
	ItemType.Attire : [],
	ItemType.Accessory : [],
	ItemType.Trap : [],
	ItemType.Consumable : [],
	ItemType.Treasure : [] 
}
