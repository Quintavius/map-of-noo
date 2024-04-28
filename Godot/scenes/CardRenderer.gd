extends Control


func render_card(card_data : Variant):
	# Common
	
	# Specific 
	match typeof(card_data):
		Item:
			pass
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
