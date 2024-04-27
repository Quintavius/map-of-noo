extends Control

@export var cycle :float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#$ColorRect.material.set("shader_parameter/Cycle", cycle)
	pass

func _on_h_slider_value_changed(value):
	$MapBase.material.set("shader_parameter/Cycle", value)
	pass # Replace with function body.
