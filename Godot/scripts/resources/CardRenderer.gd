extends Control

var cards_data = preload("res://cards/cards_data.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	_render_random_card()

func _input(event):
	var just_pressed = event.is_pressed() and not event.is_echo()
	if Input.is_key_pressed(KEY_SPACE) and just_pressed:
		_render_random_card()

func _render_random_card():
	var card_to_render = cards_data.CharacterCards[cards_data.CharacterCards.keys().pick_random()]
	render_card(card_to_render)

func render_card(card_data : Variant):
	# Common
	var has_description : bool = card_data.description != ""
	var has_skills : bool = card_data.skill_0_active || card_data.skill_1_active || card_data.skill_2_active
	#var has_effect : bool = csv_entry["Effect"] != ""
	
	$DescriptionPanel/DescriptionContents/FlourishMargin.visible = has_description && has_skills
	$DescriptionPanel/DescriptionContents/DescriptionMargin.visible = has_description
	$DescriptionPanel/DescriptionContents/SkillsContainer.visible = has_skills
	
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
