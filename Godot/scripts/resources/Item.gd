class_name Item extends Card

@export var item_type : ItemProperties.ItemType 
@export var Subcategory : String
@export var Dice : CardProperties.DiceClass

@export_range(0,3) var brains : int 
@export_range(0,3) var brawn : int 
@export_range(0,3) var tongue : int
@export_range(0,3) var hands : int

@export var attack := CardProperties.DiceClass.None
@export var defense := CardProperties.DiceClass.None

# Image generation
#@export_category("Image Generation")
#@export var adjective : String
#@export var backdrop_adjective : String
#@export var backdrop : String
