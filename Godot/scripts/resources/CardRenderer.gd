extends Control

# Debug
@export var test_data : Card

var data = preload("res://source_data/CharacterData.csv")

func render_card(card_data : Variant):
	# Common
	var csv_entry : Dictionary = data.records[0] 
	
	var has_description : bool = csv_entry["Description"] != ""
	var has_skills : bool = !(csv_entry["Skill0"] == "" && csv_entry["Skill1"] == "" && csv_entry["Skill2"] == "")
	#var has_effect : bool = csv_entry["Effect"] != ""
	
	$DescriptionPanel/DescriptionContents/FlourishMargin.visible = has_description && has_skills
	$DescriptionPanel/DescriptionContents/DescriptionMargin.visible = has_description
	$DescriptionPanel/DescriptionContents/SkillsContainer.visible = has_skills
	
	$Name.text = csv_entry["Name"]
	$Image.texture = card_data.image
	$DescriptionPanel/DescriptionContents/DescriptionMargin/Description.text = csv_entry["Description"]
	
	$Origin/OriginName.text = csv_entry["Origin"]
	$Artist/ArtistName.text = csv_entry["Artist"]
	
	# Specific 
	match card_data.CARD_TYPE:
		CardProperties.CardTypes.Character:
			#pronouns : String
			$BrainLevel.update_level(csv_entry["Brains"])
			$BrawnLevel.update_level(csv_entry["Brawn"])
			$TongueLevel.update_level(csv_entry["Tongue"])
			$HandsLevel.update_level(csv_entry["Hands"])
			
			$AtkDiceWeight.update_level(CardProperties.DiceClass[csv_entry["Attack"]])
			$DefDiceWeight.update_level(CardProperties.DiceClass[csv_entry["Defense"]])
			
			var skill_0 = $DescriptionPanel/DescriptionContents/SkillsContainer/Skill0
			if csv_entry["Skill0"] != "":
				skill_0.visible = true
				skill_0.get_node("SkillBox/SkillName").text = csv_entry["Skill0"]
				skill_0.get_node("SkillBox/LevelDisplay").update_level(csv_entry["Skill0Lv"])
			else:
				skill_0.visible = false
			
			var skill_1 = $DescriptionPanel/DescriptionContents/SkillsContainer/Skill1
			if csv_entry["Skill1"] != "":
				skill_1.visible = true
				skill_1.get_node("SkillBox/SkillName").text = csv_entry["Skill1"]
				skill_1.get_node("SkillBox/LevelDisplay").update_level(csv_entry["Skill1Lv"])
			else:
				skill_1.visible = false
			
			var skill_2 = $DescriptionPanel/DescriptionContents/SkillsContainer/Skill2
			if csv_entry["Skill2"] != "":
				skill_2.visible = true
				skill_2.get_node("SkillBox/SkillName").text = csv_entry["Skill2"]
				skill_2.get_node("SkillBox/LevelDisplay").update_level(csv_entry["Skill2Lv"])
			else:
				skill_2.visible = false
			
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	render_card(test_data)
	#sync_sheet()
	#print(csv_data[0][Name])
	

	
	#var error = http_request.request("https://docs.google.com/spreadsheets/d/1QBlhDNbKv8KKqeYgz6W9YZ88JgUDJdL4mCPGo6OTXgE//gviz/tq?tqx=out:csv&sheet=Portraits&tq=SELECT%20*%20WHERE%20A%20IS%20NOT%20NULL")
	#if error != OK:
	#	push_error("bad request")

#func _http_request_completed(result, response_code, headers, body):
	#if result != HTTPRequest.RESULT_SUCCESS:
	#	push_error("can't download data")
	
	#print(body.get_string_from_utf8())
	
	#var url_image = Image.new()
	#var error= url_image.load_png_from_buffer(body)
	#if error != OK:
	#	push_error("can't load image")
	
	#var texture = ImageTexture.create_from_image(url_image)
	
	#$Image.texture = texture

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
