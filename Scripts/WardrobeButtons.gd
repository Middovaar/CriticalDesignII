class_name OutstyleSelector
extends Button

@export_category("Emitted Outfit ID")
@export_range(0, 10, 1, "or_greater") var Outfit:int
@export_enum("Hair", "Tops", "Pant", "Shoe", "Acs", "Choker") var Type:String
@export var ActiveDuring:int
@export var CategoryChoices = 4

signal WornOutfit(Outfit:int, Type:String)
var CurrentSel = 0
var CurrGamestate

func _input(event):
	if event.is_action_pressed("Left"):
		if CurrentSel == 0:
			CurrentSel = CategoryChoices-1
		else:
			CurrentSel -= 1
	
	if event.is_action_pressed("Right"):
		if CurrentSel == CategoryChoices-1:
			CurrentSel = 0
		else:
			CurrentSel += 1
			
	if CurrentSel == Outfit:
		set_modulate(Color("fec100"))
	else:
		set_modulate(Color("white"))
		
	if Input.is_action_just_pressed("Select") and CurrGamestate == ActiveDuring:
		_on_pressed()
		pass

func _on_pressed():
	if CurrentSel == Outfit  :
		emit_signal("WornOutfit", Outfit, Type)


func _on_button_down():
	emit_signal("WornOutfit", Outfit, Type)


func _on_character_gamestate_notif(CurGamestate):
	CurrGamestate = CurGamestate
