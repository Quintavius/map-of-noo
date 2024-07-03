extends CenterContainer

var current_level := 0

var level_1 = "res://assets/interface/cards/rings_1.png"
var level_2 = "res://assets/interface/cards/rings_2.png"
var level_3 = "res://assets/interface/cards/rings_3.png"

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
