@tool
extends CenterContainer

var current_level := 0

const level_1 = preload("res://assets/interface/cards/rings_1.png")
const level_2 = preload("res://assets/interface/cards/rings_2.png")
const level_3 = preload("res://assets/interface/cards/rings_3.png")

func update_level(level):
	current_level = level
	if level == 0:
		$RingLevel.visible = false
	else:
		$RingLevel.visible = true
		
		match level:
			1: 
				$RingLevel.texture = level_1
			2:
				$RingLevel.texture = level_2
			3:
				$RingLevel.texture = level_3
