extends Control

# Debug
@export var test_data : Item

func render_card(card_data : Variant):
	# Common
	$Name.text = card_data.name
	$Image.texture = card_data.image
	$Description.text = card_data.description
	
	# Specific 
	#match typeof(card_data):
		#Item:
			#pass
	#pass

# Called when the node enters the scene tree for the first time.
func _ready():
	render_card(test_data)
	
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(self._http_request_completed)
	
	var error = http_request.request("https://cdn.discordapp.com/attachments/1133230663596777576/1234091530596126720/scringlescrongle_a_mid-thirties_crusty_troll_in_a_mossy_cellar_d8b3983a-7312-434e-845d-79b896af8bb1.png")
	if error != OK:
		push_error("bad request")

func _http_request_completed(result, response_code, headers, body):
	if result != HTTPRequest.RESULT_SUCCESS:
		push_error("can't download image")
	
	var url_image = Image.new()
	var error= url_image.load_png_from_buffer(body)
	if error != OK:
		push_error("can't load image")
	
	var texture = ImageTexture.create_from_image(url_image)
	
	$Image.texture = texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
