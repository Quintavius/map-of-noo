class_name Actor extends Card

enum Actor_State {Normal, KO, Dead}

@export var state : Actor_State = Actor_State.Normal

@export var pronouns : String

@export_range(0,3) var brains : int = 0
@export_range(0,3) var brains_exp : int = 0

@export_range(0,3) var brawn : int = 0
@export_range(0,3) var brawn_exp : int = 0

@export_range(0,3) var tongue : int = 0
@export_range(0,3) var tongue_exp : int = 0

@export_range(0,3) var hands : int = 0
@export_range(0,3) var hands_exp : int = 0

@export var attack := CardProperties.DiceClass.Light
@export var defense := CardProperties.DiceClass.Light

@export_category("Skills")
@export var skill_0_active := false
@export var skill_0_name : String
@export_range(0,3) var skill_0_level : int
@export_range(0,3) var skill_0_exp : int

@export var skill_1_active := false
@export var skill_1_name : String
@export_range(0,3) var skill_1_level : int
@export_range(0,3) var skill_1_exp : int

@export var skill_2_active := false
@export var skill_2_name : String
@export_range(0,3) var skill_2_level : int
@export_range(0,3) var skill_2_exp : int

func add_exp(stat : Dictionary) :
	if stat.level < 3 :
		if stat.experience < 3 :
			stat.experience += 1
		else:
			stat.level += 1
			stat.experience = 0
