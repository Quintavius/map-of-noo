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

func generate_cards(source, type):
	var target = load("res://cards/cards_data.tres")
	#var character_data = load("res://source_data/CharacterData.csv")
	
	var high_ages_only = source.records.filter(func(record): return record["Expansion"] == "The Worldsplitter")
	
	var cards_dictionary = {}
	
	var new_card
	var card_base_path
	
	for card_entry in high_ages_only:
		match type:
			CardProperties.CardTypes.Character :
				card_base_path = "res://assets/card_art/characters/"
				new_card = Character.new()
				new_card.card_type = CardProperties.CardTypes.Character
				new_card.species = card_entry["Species"]
				set_stats(new_card, card_entry)
				new_card.attack = CardProperties.DiceClass[card_entry["Attack"]]
				new_card.defense = CardProperties.DiceClass[card_entry["Defense"]]
				set_skills(new_card, card_entry)
			
			CardProperties.CardTypes.Item : 
				new_card = Item.new()
				var item_type = card_entry["Type"]
				card_base_path = "res://assets/card_art/items/"
				match item_type:
					"Weapon":
						new_card.card_type = CardProperties.CardTypes.Weapon
						new_card.attack = CardProperties.DiceClass[card_entry["Stat"]]
					"Attire":
						new_card.card_type = CardProperties.CardTypes.Attire
						new_card.defense = CardProperties.DiceClass[card_entry["Stat"]]
					"Accessory":
						new_card.card_type = CardProperties.CardTypes.Accessory
					"Consumable":
						new_card.card_type = CardProperties.CardTypes.Consumable
					"Trap":
						new_card.card_type = CardProperties.CardTypes.Trap
					"Treasure":
						new_card.card_type = CardProperties.CardTypes.Treasure
				
			CardProperties.CardTypes.Creature :
				card_base_path = "res://assets/card_art/creatures/"
				new_card = Creature.new()
				new_card.card_type = CardProperties.CardTypes.Creature
				new_card.attack = CardProperties.DiceClass[card_entry["Attack"]]
				new_card.defense = CardProperties.DiceClass[card_entry["Defense"]]
			
			CardProperties.CardTypes.Place :
				pass
				#new_card = Place.new()
		
		# Set up common shit
		new_card.name = card_entry["Name"]
		new_card.era = card_entry["Era"]
		new_card.description = card_entry["Description"]
		new_card.effect = card_entry["Effect"]
		new_card.culture = card_entry["Origin"]
		new_card.artist = card_entry["Artist"]
		var image_location = card_base_path + card_entry["Name"] + ".png"
		if ResourceLoader.exists(image_location):
			new_card.image = load(image_location)
		else:
			print("Missing image: " + image_location)
		
		# Attach to dictionary
		cards_dictionary[new_card.name] = new_card
		# Save dictionary as resource
	
	match type:
		CardProperties.CardTypes.Character:
			target.CharacterCards = cards_dictionary
		CardProperties.CardTypes.Item:
			target.ItemCards = cards_dictionary
		CardProperties.CardTypes.Creature:
			target.CreatureCards = cards_dictionary
			#add place later
	
	print("Created " + str(cards_dictionary.size()) + " cards.")

func set_stats(card, entry) :
		card.brains = entry["Brains"]
		card.brawn = entry["Brawn"]
		card.tongue = entry["Tongue"]
		card.hands = entry["Hands"]

func set_skills(card, entry) :
		card.skill_0_active = entry["Skill0"] != ""
		card.skill_0_name = entry["Skill0"]
		card.skill_0_level = int(entry["Skill0Lv"])
		
		card.skill_1_active = entry["Skill1"] != ""
		card.skill_1_name = entry["Skill1"]
		card.skill_1_level = int(entry["Skill1Lv"])
		
		card.skill_2_active = entry["Skill2"] != ""
		card.skill_2_name = entry["Skill2"]
		card.skill_2_level = int(entry["Skill2Lv"])

func export_characters(path, data):
	var subviewport : SubViewport = $CharacterExport
	var renderer = $CharacterExport/CardRenderer
	
	for character_card in data:
		renderer.render_card(data[character_card])
		subviewport.render_target_update_mode = SubViewport.UPDATE_ONCE
		await RenderingServer.frame_pre_draw
		await RenderingServer.frame_post_draw
		var rendered_image = subviewport.get_texture().get_image()
		rendered_image.convert(Image.FORMAT_RGBA8)
		rendered_image.save_png(path + character_card + ".png")
	print("Export completed.")

func _on_generate_characters():
	generate_cards(load("res://source_data/CharacterData.csv"), CardProperties.CardTypes.Character)

func _on_download_characters():
	sync_sheet("Portraits", "res://source_data/CharacterData.csv")

func _on_download_creatures():
	sync_sheet("Creatures", "res://source_data/CreatureData.csv")

func _on_download_items():
	sync_sheet("Items", "res://source_data/ItemData.csv")

func _on_export_characters():
	var cards_data = load("res://cards/cards_data.tres")
	var character_cards : Dictionary = cards_data.CharacterCards
	export_characters("res://export/characters/", character_cards)

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

func sync_sheet(sheet, file) -> bool:
	var url := "https://docs.google.com/spreadsheets/d/" + "1QBlhDNbKv8KKqeYgz6W9YZ88JgUDJdL4mCPGo6OTXgE" + "/gviz/tq"
	request(url, func(r, err): sync_sheet_callback(r, err), HTTPClient.METHOD_GET, {"tqx": "out:csv", "sheet": sheet, "tq":"SELECT * WHERE A IS NOT NULL", "headers":"1"}, {}, [], file)
	return true

func sync_sheet_callback(r, err) -> void:
	pass


func _on_generate_creatures():
	generate_cards(load("res://source_data/CreatureData.csv"), CardProperties.CardTypes.Creature)


func _on_generate_items():
	generate_cards(load("res://source_data/ItemData.csv"), CardProperties.CardTypes.Item)


func _on_export_items():
	var cards_data = load("res://cards/cards_data.tres")
	var character_cards : Dictionary = cards_data.ItemCards
	export_characters("res://export/items/", character_cards)


func _on_export_creatures():
	var cards_data = load("res://cards/cards_data.tres")
	var character_cards : Dictionary = cards_data.CreatureCards
	export_characters("res://export/creatures/", character_cards)
