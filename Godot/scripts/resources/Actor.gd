class_name Actor extends Node

enum Actor_State {Normal, KO, Dead}

@export var state : Actor_State

@export var brains : Dictionary = {level = 0, experience = 0 }
@export var brawn : int
@export var tongue : int
@export var hands : int
@export var skin : int

@export var attack : CardProperties.DiceClass
@export var defense : CardProperties.DiceClass

@export var dreamwalking : Array[CardProperties.DreamwalkingSchools]
