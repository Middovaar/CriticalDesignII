extends AnimatedSprite2D

signal InitializeDialogue
signal DialogueRequest(DialoqueBlurb:int)
signal GamestateNotif(CurGamestate:int)
var CanChooseChar:bool = true

var Gamestate:int 
var CurrentAnchor = position

var WardrobeVisible = false
var confirmationCheck = 0
var EveryOther = 0

func _process(delta):
	match Gamestate: 
		100:
			position.x = lerpf(position.x, %Anchor1.position.x, 0.04)
			%Wardrobe.position.x = lerpf(%Wardrobe.position.x, %AnchorWardrobe.position.x, 0.04)
			emit_signal("GamestateNotif", 100)
			WardrobeVisible = true
		200:
			emit_signal("GamestateNotif", 200)
			%Wardrobe.position.x = lerpf(%Wardrobe.position.x, %AnchorWardrobeOut.position.x, 0.04)
			%WardrobeTops.position.x = lerpf(%WardrobeTops.position.x, %AnchorWardrobe.position.x, 0.04)
			await get_tree().create_timer(1.0).timeout
		300:
			emit_signal("GamestateNotif", 300)
			%WardrobeTops.position.x = lerpf(%WardrobeTops.position.x, %AnchorWardrobeOut.position.x, 0.04)
			%WardrobePant.position.x = lerpf(%WardrobePant.position.x, %AnchorWardrobe.position.x, 0.04)
			await get_tree().create_timer(1.0).timeout
		400:
			emit_signal("GamestateNotif", 400)
			%WardrobePant.position.x = lerpf(%WardrobePant.position.x, %AnchorWardrobeOut.position.x, 0.04)
			%WardrobeShoe.position.x = lerpf(%WardrobeShoe.position.x, %AnchorWardrobe.position.x, 0.04)
			await get_tree().create_timer(1.0).timeout
		500:
			emit_signal("GamestateNotif", 500)
			%WardrobeShoe.position.x = lerpf(%WardrobeShoe.position.x, %AnchorWardrobeOut.position.x, 0.04)
			%WardrobeAcc.position.x = lerpf(%WardrobeAcc.position.x, %AnchorWardrobe.position.x, 0.04)
			await get_tree().create_timer(1.0).timeout
		600:
			emit_signal("GamestateNotif", 600)
			%WardrobeAcc.position.x = lerpf(%WardrobeAcc.position.x, %AnchorWardrobeOut.position.x, 0.04)
			position.x = lerpf(position.x, %Anchor2.position.x, 0.04)
			await get_tree().create_timer(1.0).timeout



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _input(event):
	#region Player May cycle between characters
	if CanChooseChar:
		if event.is_action_pressed("Left"):
			if frame == 0:
				frame = 2
			else:
				frame = (get_frame()-1) % 3
		if event.is_action_pressed("Right"):
			frame = (get_frame()+1) % 3
	#endregion
	
	if event.is_action_pressed("Confirm") and CanChooseChar:
		CanChooseChar = false
		emit_signal("InitializeDialogue")

	if event.is_action_pressed("Confirm") and confirmationCheck == 1:
		Gamestate = GameStateChecker(Gamestate)

func GameStateChecker(Gamestate):
	match Gamestate:
		100: 
			confirmationCheck = 0
			return 200
		200:
			confirmationCheck = 0
			return 300
		300:
			confirmationCheck = 0
			return 400
		400:
			confirmationCheck = 0
			return 500
		500:
			confirmationCheck = 0
			emit_signal("DialogueRequest", 600)
			return 600

func _on_text_handler_finished_dialogue_block(DialogueBlock):
	match DialogueBlock:
		100:
			Gamestate = 100
			


func _on_button_worn_outfit(Outfit, Type):
	var Rand
	if WardrobeVisible == true:
		if Gamestate == 100:
			$White.visible = false
			$Brown.visible = false
			$Black.visible = false
			$Red.visible = false
		elif Gamestate == 200:
			$Top1.visible = false
			$Top2.visible = false
			$Top3.visible = false
			$Top4.visible = false
		elif Gamestate == 300:
			$Pants.visible = false
			$Pants2.visible = false
			$Skirt.visible = false
			$Skirt2.visible = false
		elif Gamestate == 400:
			$S1.visible = false
			$S2.visible = false
			$S3.visible = false
			$S4.visible = false
		elif Gamestate == 500:
			$A1.visible = false
			$A2.visible = false
			$A3.visible = false
			$A4.visible = false
		
		print(Outfit, Type)
		Rand = randi_range(1, 20)
		
		if Rand > 16:
			emit_signal("DialogueRequest", 20)
		match Type:
			"Hair":
				HairSelector(Outfit)
			"Tops":
				TopsSelector(Outfit)
			"Pant":
				PantSelector(Outfit)
			"Shoe":
				ShoeSelector(Outfit)
			"Acs":
				AccSelector(Outfit)
	
func HairSelector(Outfit):
	match Outfit:
		0:
			$Red.visible = true
			confirmationCheck = 1
		1:
			$Black.visible = true
			confirmationCheck = 1
		2:
			$Brown.visible = true
			confirmationCheck = 1
		3:
			$White.visible = true
			confirmationCheck = 1
func TopsSelector(Outfit):
	match Outfit:
		0:
			$Top1.visible = true
			confirmationCheck = 1
		1:
			$Top2.visible = true
			confirmationCheck = 1
		2:
			$Top3.visible = true
			confirmationCheck = 1
		3:
			$Top4.visible = true
			confirmationCheck = 1
func PantSelector(Outfit):
	match Outfit:
		0:
			$Pants.visible = true
			confirmationCheck = 1
		1:
			$Pants2.visible = true
			confirmationCheck = 1
		2:
			$Skirt.visible = true
			confirmationCheck = 1
		3:
			$Skirt2.visible = true
			confirmationCheck = 1
func ShoeSelector(Outfit):
	match Outfit:
		0:
			$S1.visible = true
			confirmationCheck = 1
		1:
			$S2.visible = true
			confirmationCheck = 1
		2:
			$S3.visible = true
			confirmationCheck = 1
		3:
			$S4.visible = true
			confirmationCheck = 1
func AccSelector(Outfit):
	match Outfit:
		0:
			$A1.visible = true
			confirmationCheck = 1
		1:
			$A2.visible = true
			confirmationCheck = 1
		2:
			$A3.visible = true
			confirmationCheck = 1
		3:
			$A4.visible = true
			confirmationCheck = 1

func _on_top_worn_outfit(Outfit, Type):
	var Rand
	if WardrobeVisible == true:
		if Gamestate == 200:
			$Top1.visible = false
			$Top2.visible = false
			$Top3.visible = false
			$Top4.visible = false # Replace with function body.
	Rand = randi_range(1, 20)
		
	if Rand > 16:
		emit_signal("DialogueRequest", 20)
	match Type:
		"Hair":
			HairSelector(Outfit)
		"Tops":
			TopsSelector(Outfit)
