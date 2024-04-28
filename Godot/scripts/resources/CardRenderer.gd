extends Control

# Debug
@export var test_data : Item

func render_card(card_data : Variant):
	# Common
	$Name.text = card_data.name
	$Image.texture = card_data.image
	$Description.text = card_data.description
	
	# Specific 
	#match typeof(card_data):
		#Item:
			#pass
	#pass

# Called when the node enters the scene tree for the first time.
func _ready():
	render_card(test_data)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
