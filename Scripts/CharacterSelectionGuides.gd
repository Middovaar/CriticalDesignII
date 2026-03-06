extends RichTextLabel

@export_enum("Left", "Right") var Type:String


func _on_text_handler_character_has_been_confirmed(): 
	text = ""


func _on_text_handler_dialogue_options(Options):
	match Options:
		"YesNo":
			if Type == "Left":
				text = "[bgcolor=9f4178][center][color=#ffffff][blinky speed=4 minimums=0.55]< No"
			else:
				text = "[bgcolor=9f4178][center][color=#ffffff][blinky speed=4 minimums=0.55]Yes >"
