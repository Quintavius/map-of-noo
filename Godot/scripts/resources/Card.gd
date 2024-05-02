extends Resource
class_name Card

@export var name : String
@export var culture : CardProperties.Culture
#can use @export_enum : String for this
@export var artist : CardProperties.Artist
@export_multiline var description : String
@export_multiline var effect : String
@export var image : Texture2D
@export var legendary : bool
