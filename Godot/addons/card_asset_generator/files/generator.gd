@tool
extends Control

#var file_dialog : EditorFileDialog



#Debug, protects from running when editing scene file
var should_setup : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if !should_setup:
		return
	
	#file_dialog = EditorFileDialog.new()
	#file_dialog.file_mode = EditorFileDialog.FILE_MODE_SAVE_FILE
	#file_dialog.add_filter("*.tres")
	#file_dialog.file_selected.connect(_on_add_file_selected)
	#add_child(file_dialog)

func download_characters():
	sync_sheet()

func generate_characters():
	var cards_resource = load("res://cards/cards_data.tres")
	var character_data = load("res://source_data/CharacterData.csv")
	
	var high_ages_only = character_data.records.filter(func(record): return record["Era"] == "High Ages" && record["Species"] != "Chaos God")
	
	var characters_dictionary = {}
	for character_entry in high_ages_only:
		var new_character = Character.new()
		
		# Extract all necessary info
		new_character.name = character_entry["Name"]
		new_character.era = character_entry["Era"]
		new_character.species = character_entry["Species"]
		
		var image_location = "res://assets/card_art/characters/" + character_entry["Name"] + ".png"
		if ResourceLoader.exists(image_location):
			new_character.image = load("res://assets/card_art/characters/" + character_entry["Name"] + ".png")
		else:
			print("Missing image: " + image_location)
		
		new_character.brains = character_entry["Brains"]
		new_character.brawn = character_entry["Brawn"]
		new_character.tongue = character_entry["Tongue"]
		new_character.hands = character_entry["Hands"]
		
		new_character.description = character_entry["Description"]
		
		new_character.attack = CardProperties.DiceClass[character_entry["Attack"]]
		new_character.defense = CardProperties.DiceClass[character_entry["Defense"]]
		
		new_character.skill_0_active = character_entry["Skill0"] != ""
		new_character.skill_0_name = character_entry["Skill0"]
		new_character.skill_0_level = int(character_entry["Skill0Lv"])
		
		new_character.skill_1_active = character_entry["Skill1"] != ""
		new_character.skill_1_name = character_entry["Skill1"]
		new_character.skill_1_level = int(character_entry["Skill1Lv"])
		
		new_character.skill_2_active = character_entry["Skill2"] != ""
		new_character.skill_2_name = character_entry["Skill2"]
		new_character.skill_2_level = int(character_entry["Skill2Lv"])
		
		new_character.culture = character_entry["Origin"]
		new_character.artist = character_entry["Artist"]
		# Attach to dictionary
		characters_dictionary[new_character.name] = new_character
	# Save dictionary as resource
	cards_resource.CharacterCards = characters_dictionary
	print("Created " + str(characters_dictionary.size()) + " characters.")

func _on_generate_characters():
	generate_characters()


func _on_download_characters():
	download_characters()

const HEADER = ["Content-Type: application/json; charset=UTF-8"]
func request(url: String, callback: Callable, method: HTTPClient.Method = HTTPClient.METHOD_GET, query: Dictionary = {}, body: Dictionary = {}, headers: Array = HEADER, path: String = "") -> Error:
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(func(r,c,h,b): _request_completed(r, c, h, b, callback))
	
	var QUERY = "?" + "&".join(query.keys().map(func(k): return k.uri_encode() + "=" + str(query[k]).uri_encode()))
	var error: Error
	var body_str = JSON.new().stringify(body) if body else ""
	
	if path != "":
		http_request.set_download_file(path)
	error = http_request.request(url + QUERY, headers, method, body_str)
	print(url + QUERY)
	if error != OK:
		push_error("Bad HTTP request. Code error most likely")
	return error

func _request_completed(result, response_code, headers, body, callback: Callable):
	print("REQ COMPLETED. Result:" + str(result) + " response_code: " + str(response_code))
	var err = OK
	if result != HTTPRequest.RESULT_SUCCESS:
		printerr("ERROR: You're offline")
		err = result
	elif response_code >= 400:
		printerr("ERROR: Invalid request")
		err = response_code
	
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	callback.call(response, err)
	
	if err != OK:
		printerr("ERROR response: ", response)

func sync_sheet() -> bool:
	var url := "https://docs.google.com/spreadsheets/d/" + "1QBlhDNbKv8KKqeYgz6W9YZ88JgUDJdL4mCPGo6OTXgE" + "/gviz/tq"
	request(url, func(r, err): sync_sheet_callback(r, err), HTTPClient.METHOD_GET, {"tqx": "out:csv", "sheet": "Portraits", "tq":"SELECT * WHERE A IS NOT NULL", "headers":"1"}, {}, [], "res://source_data/CharacterData.csv")
	return true

func sync_sheet_callback(r, err) -> void:
	pass
