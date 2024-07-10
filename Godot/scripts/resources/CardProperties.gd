extends Node
class_name CardProperties 

enum DiceClass{Light, Medium, Heavy}

enum CardTypes{Character, Creature, Item, Place}

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
