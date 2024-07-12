@tool
extends EditorPlugin

var generator_instance

func _enter_tree():
	# This reloads every time the plugin is activated
	var packed : PackedScene = load("res://addons/card_asset_generator/files/generator.tscn")
	generator_instance = packed.instantiate()
	
	add_control_to_bottom_panel(generator_instance, "Card Generator")

func _exit_tree():
	if generator_instance:
		remove_control_from_bottom_panel(generator_instance)
		generator_instance.queue_free()
