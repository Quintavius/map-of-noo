@tool
extends Resource
class_name Card

var card_type : CardProperties.CardTypes
@export var name : String
@export var era : String
@export var culture : String
#can use @export_enum : String for this
@export var artist : String
@export_multiline var description : String
@export_multiline var effect : String
@export var image : Texture2D
@export var legendary : bool
