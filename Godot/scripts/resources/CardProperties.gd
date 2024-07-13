@tool
extends Node
class_name CardProperties 

enum DiceClass{None, Light, Medium, Heavy}

enum CardTypes{Character, Creature, Weapon, Item, Attire, Consumable, Trap, Treasure, Accessory, Place}

enum Culture{
	AetherMafia
}

const Cultures : Dictionary = {
	Culture.AetherMafia : {"name": "Aether Mafia", "value": "soar-mafia guild-noir"}
}

enum Artist{
	AaronLimhop
}

const Artists : Dictionary = {
	Artist.AaronLimhop : {"name": "Aaron Limhop", "value": "Juxtapoz dark art, subsurface scattering, by Maya Hayuk, bloom, maximalist, by Sebastian Schrader"}
	}

enum DreamwalkingSchools {
	Nuclear
}

const CardStyles : Dictionary = {
	"CharacterStyle" = {
		"BaseColor" = Color(0.396, 0.149, 0.125),
		"AccentColor" = Color(0.396, 0.149, 0.125),
		"Frame" = "res://assets/interface/cards/characters_frame.png"
	},
	"CreatureStyle" = {
		"BaseColor" = Color(0.243, 0.224, 0.302),
		"AccentColor" = Color(0.451, 0.384, 0.51),
		"Frame" = "res://assets/interface/cards/creatures_frame.png"
	},
	"PlaceStyle" = {
		"BaseColor" = Color(0.204, 0.294, 0.412),
		"AccentColor" = Color(0.294, 0.482, 0.702),
		"Frame" = "res://assets/interface/cards/characters_frame.png"
	},
	"WeaponStyle" = {
		"BaseColor" = Color(0.455, 0.196, 0.129),
		"AccentColor" = Color(0.761, 0.431, 0.157),
		"Frame" = "res://assets/interface/cards/weapons_frame.png"
	},
	"AttireStyle" = {
		"BaseColor" = Color(0.165, 0.373, 0.361),
		"AccentColor" = Color(0.294, 0.663, 0.702),
		"Frame" = "res://assets/interface/cards/attire_frame.png"
	},
	"AccessoryStyle" = {
		"BaseColor" = Color(0.365, 0.173, 0.212),
		"AccentColor" = Color(0.824, 0.455, 0.49),
		"Frame" = "res://assets/interface/cards/accessories_frame.png"
	},
	"TrapStyle" = {
		"BaseColor" = Color(0.196, 0.18, 0.165),
		"AccentColor" = Color(0.537, 0.498, 0.459),
		"Frame" = "res://assets/interface/cards/traps_frame.png"
	},
	"ConsumableStyle" = {
		"BaseColor" = Color(0.278, 0.286, 0.176),
		"AccentColor" = Color(0.553, 0.612, 0.384),
		"Frame" = "res://assets/interface/cards/consumables_frame.png"
	},
	"TreasureStyle" = {
		"BaseColor" = Color(0.353, 0.243, 0.11),
		"AccentColor" = Color(0.718, 0.545, 0.282),
		"Frame" = "res://assets/interface/cards/treasures_frame.png"
	}
} 
