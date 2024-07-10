extends Resource
class_name Card

@export var name : String
@export_enum("Secorran Guard", "Emerald Garden", "Dreamwalker Academy") var culture : String
#can use @export_enum : String for this
@export_enum("Paladius Stex", "Borique Boutique", "Ponder") var artist : String
@export_multiline var description : String
@export_multiline var effect : String
@export var image : Texture2D
@export var legendary : bool
