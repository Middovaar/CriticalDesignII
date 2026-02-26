@tool
extends RichTextEffect
class_name Blinky

var bbcode = "blinky"

func _process_custom_fx(char_fx: CharFXTransform) -> bool:
	var speed = char_fx.env.get("speed", 1)
	var minimums = char_fx.env.get("minimums", 0.5)
	char_fx.color.a -= (char_fx.color.a * ((sin(char_fx.elapsed_time*speed))/2))+minimums
	return true
