@tool
extends TextureRect

var current_weight := CardProperties.DiceClass.Light

const light = preload("res://assets/interface/cards/dice_light.png")
const medium = preload("res://assets/interface/cards/dice_medium.png")
const heavy = preload("res://assets/interface/cards/dice_heavy.png")

func update_level(weight):
	current_weight = weight
	match weight:
		CardProperties.DiceClass.Light: 
			self.texture = light
		CardProperties.DiceClass.Medium:
			self.texture = medium
		CardProperties.DiceClass.Heavy:
			self.texture = heavy
