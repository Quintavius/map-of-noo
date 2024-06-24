class_name Actor extends Card

enum Actor_State {Normal, KO, Dead}

@export var state : Actor_State

@export var pronouns : String

@export var brains : Dictionary = {level = 0, experience = 0 }
@export var brawn : Dictionary = {level = 0, experience = 0 }
@export var tongue : Dictionary = {level = 0, experience = 0 }
@export var hands : Dictionary = {level = 0, experience = 0 }
@export var skin : Dictionary = {level = 0, experience = 0 }

@export var attack : CardProperties.DiceClass
@export var defense : CardProperties.DiceClass

@export var dreamwalking : Array[CardProperties.DreamwalkingSchools]

func add_exp(stat : Dictionary) :
	if stat.level < 3 :
		if stat.experience < 3 :
			stat.experience += 1
		else:
			stat.level += 1
			stat.experience = 0
