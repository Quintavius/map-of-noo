extends Control

# Debug
@export var test_data : Card

var csv_data = "res://source_data/ROALD Cards - Portraits.csv"

func render_card(card_data : Variant):
	# Common
	$Name.text = card_data.name
	$Image.texture = card_data.image
	$DescriptionPanel/DescriptionContents/DescriptionMargin/Description.text = card_data.description
	
	$Origin/OriginName.text = card_data.culture
	$Artist/ArtistName.text = card_data.artist
	
	# Specific 
	match card_data.CARD_TYPE:
		CardProperties.CardTypes.Character:
			#pronouns : String
			$BrainLevel.update_level(card_data.brains)
			$BrawnLevel.update_level(card_data.brawn)
			$TongueLevel.update_level(card_data.tongue)
			$HandsLevel.update_level(card_data.hands)
			
			$AtkDiceWeight.update_level(card_data.attack)
			$DefDiceWeight.update_level(card_data.defense)
			
			var skill_0 = $DescriptionPanel/DescriptionContents/SkillsContainer/Skill0
			skill_0.visible = card_data.skill_0_active
			skill_0.get_node("SkillBox/SkillName").text = card_data.skill_0_name
			skill_0.get_node("SkillBox/LevelDisplay").update_level(card_data.skill_0_level)
			
			var skill_1 = $DescriptionPanel/DescriptionContents/SkillsContainer/Skill1
			skill_1.visible = card_data.skill_1_active
			skill_1.get_node("SkillBox/SkillName").text = card_data.skill_1_name
			skill_1.get_node("SkillBox/LevelDisplay").update_level(card_data.skill_1_level)
			
			var skill_2 = $DescriptionPanel/DescriptionContents/SkillsContainer/Skill2
			skill_2.visible = card_data.skill_2_active
			skill_2.get_node("SkillBox/SkillName").text = card_data.skill_2_name
			skill_2.get_node("SkillBox/LevelDisplay").update_level(card_data.skill_2_level)
			
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	render_card(test_data)
	sync_sheet()
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
	request(url, func(r, err): sync_sheet_callback(r, err), HTTPClient.METHOD_GET, {"tqx": "out:csv", "sheet": "Items", "tq":"SELECT * WHERE A IS NOT NULL"}, {}, [], "res://source_data/ItemData.csv")
	return true

func sync_sheet_callback(r, err) -> void:
	pass
