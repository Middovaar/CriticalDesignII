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
var ReadyText
var DisplayedText = ""
var TextIsAnimated = false

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

func RenderText():
# Recursively renders out each text segment in the Readied Text until empty
	for TextSegmentCounter in ReadyText.size():
		TextIsAnimated = true
		DisplayedText += ReadyText[TextSegmentCounter]
		await get_tree().create_timer(AnimationSpeed).timeout
		%TextBox.text = DisplayedText
	TextIsAnimated = false

func DialogueSwitchBoard(DialogueUUID):
	### DialogueSwitchBoard
	# This Function serves as a Switchboard that routes the appropraite dialogue
	# from the JSON to the RenderText Function
	# 
	# The Id, is catches here, and pushed as DialogueReq
	# Based on DialogueReq, run match and recieve the appropriate Dialogue.address
	var DialogueAdress
	
	match DialogueUUID:
		1:
			DialogueAdress = Dialogue.ID1.Text
	
	return DialogueAdress
