class_name Item extends Card

@export var item_type : ItemProperties.ItemType 
@export var Subcategory : String
@export var Dice : CardProperties.DiceClass

# Image generation
@export_category("Image Generation")
@export var adjective : String
@export var backdrop_adjective : String
@export var backdrop : String
