@tool
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
	# Confirm card data
	var has_description : bool = card_data.description != ""
	var has_skills : bool ="skill_0_active" in card_data &&  (card_data.skill_0_active || card_data.skill_1_active || card_data.skill_2_active)
	var has_effect : bool = card_data.effect != ""
	var has_attack : bool = "attack" in card_data && card_data.attack != CardProperties.DiceClass.None
	var has_defense : bool = "defense" in card_data && card_data.defense != CardProperties.DiceClass.None
	var has_stats: bool = "brains" in card_data
	
	# Toggle component visibility
	$DescriptionPanel/DescriptionContents/FlourishMargin.visible = has_description && (has_skills || has_effect)
	$DescriptionPanel/DescriptionContents/DescriptionMargin.visible = has_description
	$DescriptionPanel/DescriptionContents/SkillsContainer.visible = has_skills
	$DescriptionPanel/DescriptionContents/EffectMargin.visible = has_effect
	# Consolidate these
	$AtkDiceWeight.visible = has_attack
	$Attack.visible = has_attack
	$DefDiceWeight.visible = has_defense
	$Defense.visible = has_defense
	$BrainLevel.visible = has_stats
	$BrawnLevel.visible = has_stats
	$TongueLevel.visible = has_stats
	$HandsLevel.visible = has_stats
	
	# Style card
	match card_data.card_type:
		CardProperties.CardTypes.Character :
			set_card_style(CardProperties.CardStyles.CharacterStyle) 
		CardProperties.CardTypes.Creature :
			set_card_style(CardProperties.CardStyles.CreatureStyle) 
		CardProperties.CardTypes.Weapon :
			set_card_style(CardProperties.CardStyles.WeaponStyle) 
		CardProperties.CardTypes.Attire :
			set_card_style(CardProperties.CardStyles.AttireStyle) 
		CardProperties.CardTypes.Consumable :
			set_card_style(CardProperties.CardStyles.ConsumableStyle) 
		CardProperties.CardTypes.Trap :
			set_card_style(CardProperties.CardStyles.TrapStyle) 
		CardProperties.CardTypes.Treasure :
			set_card_style(CardProperties.CardStyles.TreasureStyle) 
		CardProperties.CardTypes.Accessory :
			set_card_style(CardProperties.CardStyles.AccessoryStyle) 
		CardProperties.CardTypes.Place :
			set_card_style(CardProperties.CardStyles.PlaceStyle) 
	
	# Set card values
	$Name.text = card_data.name
	$Image.texture = card_data.image
	$DescriptionPanel/DescriptionContents/DescriptionMargin/Description.text = card_data.description
	
	$Origin/OriginName.text = card_data.culture
	$Artist/ArtistName.text = card_data.artist
	
	if has_effect:
		$DescriptionPanel/DescriptionContents/EffectMargin/Effect.text = card_data.effect
	
	if has_stats:
		$BrainLevel.update_level(card_data.brains)
		$BrawnLevel.update_level(card_data.brawn)
		$TongueLevel.update_level(card_data.tongue)
		$HandsLevel.update_level(card_data.hands)
	
	if has_attack:
		$AtkDiceWeight.update_level(card_data.attack)
	
	if has_defense:
		$DefDiceWeight.update_level(card_data.defense)
	
	if has_skills:
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


func set_card_style(card_style : Dictionary):
	# Set base colors
	var base_components = [
		$DescriptionEdge,
		$HandsLevel/RingOutline,
		$BrainLevel/RingOutline,
		$BrawnLevel/RingOutline,
		$TongueLevel/RingOutline,
		$DescriptionPanel/DescriptionContents/SkillsContainer/Skill0/SkillBox/LevelDisplay/RingOutline,
		$DescriptionPanel/DescriptionContents/SkillsContainer/Skill1/SkillBox/LevelDisplay/RingOutline,
		$DescriptionPanel/DescriptionContents/SkillsContainer/Skill2/SkillBox/LevelDisplay/RingOutline,
		$Defense/DefFront,
		$Attack/AtkFront,
		$Origin,
		$Artist
	]
	for component in base_components:
		component.self_modulate = card_style.BaseColor
	
	# Set accent colors
	var accent_components = [
		$DefDiceWeight,
		$AtkDiceWeight,
		$DescriptionPanel/DescriptionContents/FlourishMargin/Flourish,
		$HandsLevel/RingLevel,
		$BrainLevel/RingLevel,
		$BrawnLevel/RingLevel,
		$TongueLevel/RingLevel,
		$DescriptionPanel/DescriptionContents/SkillsContainer/Skill0/SkillBox/LevelDisplay/RingLevel,
		$DescriptionPanel/DescriptionContents/SkillsContainer/Skill1/SkillBox/LevelDisplay/RingLevel,
		$DescriptionPanel/DescriptionContents/SkillsContainer/Skill2/SkillBox/LevelDisplay/RingLevel,
	]
	for component in accent_components:
		component.self_modulate = card_style.AccentColor

	
	# Set frame
	$Frame.texture = load(card_style.Frame)
