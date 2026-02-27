class_name DialogueHandler
extends Control

@export_category("Text Properties")
@export_range(0.01, 1.00, 0.01,"or_greater", "suffix:sec") var AnimationSpeed:float = 0.07

#region that contains Singleton Path to Dialogue JSON, replace with user:// when exporting(?)
@onready var DialoguePath = "res://Dialogue/Dialogue.json"
# Dialogue Singleton
var Dialogue: Dictionary = {} 
#endregion

### Text Handlers ###

var DisplayedText = ""
var TextIsAnimated = false

var TextCompounder
var ReadyText:Array 

signal CharacterHasBeenConfirmed
signal FinishedDialogueBlock(DialogueBlock:int)

func _ready():
	#region that contains Loads the Dialogue Data into Variable Form
	
	var file = FileAccess.open(DialoguePath, FileAccess.READ)
	var parser = file.get_as_text()
	var jsonObject = JSON.new()
	#region Error Handler
	assert(file.file_exists(DialoguePath), "Attempted to load Json, and json does not exist!")
	#endregion
	jsonObject.parse(parser)
	Dialogue = jsonObject.data
	#endregion
	%TextBox.text = "" #Nulls the text box

func RenderText(DialogueUUID):
	# Detects how many lines of texts there are in a given dialogue block
	if TextCompounder == 0 or TextCompounder == null:
		TextCompounder = DialogueItemBoard(DialogueUUID)
	#The array containing the actively rendered text
	ReadyText = DialogueSwitchBoard(DialogueUUID+TextCompounder-1)
# Recursively renders out each text segment in the Readied Text until empty
	for TextSegmentCounter in ReadyText.size():
		TextIsAnimated = true
		DisplayedText += ReadyText[TextSegmentCounter]
		await get_tree().create_timer(AnimationSpeed).timeout
		%TextBox.text = DisplayedText
	
	TextIsAnimated = false
	TextCompounder -= 1
	await %Space.ExpectedPress
	if TextCompounder != 0:
		DialogueClear()
		RenderText(DialogueUUID)
	else:
		emit_signal("FinishedDialogueBlock", DialogueUUID)
		DialogueClear()

func DialogueClear():
	%TextBox.text = ""
	DisplayedText = ""
	ReadyText = []


func DialogueSwitchBoard(DialogueUUID):
	### DialogueSwitchBoard
	# This Function serves as a Switchboard that routes the appropraite dialogue
	# from the JSON to the RenderText Function
	# 
	# The Id, is catches here, and pushed as DialogueReq
	# Based on DialogueReq, run match and recieve the appropriate Dialogue.address
	var DialogueAdress
	
	match DialogueUUID:
		106:
			DialogueAdress = Dialogue.DressupStart.A
		105:
			DialogueAdress = Dialogue.DressupStart.B
		104:
			DialogueAdress = Dialogue.DressupStart.C
		103:
			DialogueAdress = Dialogue.DressupStart.D
		102:
			DialogueAdress = Dialogue.DressupStart.E
		101:
			DialogueAdress = Dialogue.DressupStart.F
		100:
			DialogueAdress = Dialogue.DressupStart.G
		20:
			DialogueAdress = Dialogue.DressupHair.A
		600:
			DialogueAdress = Dialogue.DressupEnd.A
		
	
	return DialogueAdress

func DialogueItemBoard(DialogueUUID):
	### DialogueItemBoard
	# This Function serves as a ItemTableLookup that grabs how many dialogue lines there is in a block
	# from the JSON to the RenderText Function
	# 
	# The Id, is catches here, and pushed as DialogueReq
	# Based on DialogueReq, run match and recieve the appropriate Dialogue.address
	var DialogueItems:int
	match DialogueUUID:
		100:
			DialogueItems = Dialogue.DressupStart.Items
		20:
			DialogueItems = Dialogue.DressupHair.Items
		600:
			DialogueItems = Dialogue.DressupEnd.Items
	return DialogueItems

func _onCharConfirmation():
	emit_signal("CharacterHasBeenConfirmed")
	%Space.text = ""
	RenderText(100)


func _on_character_dialogue_request(DialoqueBlurb):
	RenderText(DialoqueBlurb)
