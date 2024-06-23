extends Node2D

var hovering := false
var card_selected := false

# TODO HIGHLIGHT CARD

func _on_button_mouse_entered():
	if Global.clicking_enabled:
		hovering = true
		var tween = create_tween()
		highlight_tween(tween)

func _on_button_mouse_exited():
	if Global.clicking_enabled:
		hovering = false
		var tween = create_tween()
		normal_tween(tween)

func _on_button_down():
	if Global.clicking_enabled:
		var tween = create_tween()
		tween.tween_property($ColorRect, "scale", Vector2(4.5, 4.5), 0.1)
		if hovering:
			highlight_tween(tween)
		else:
			normal_tween(tween)
		if !card_selected:
			$ColorRect/Highlight.color = Color(Color.WHITE, 0.5)
			card_selected = true
		else:
			$ColorRect/Highlight.color = Color(Color.WHITE, 0.0)
			card_selected = false

func highlight_tween(tween):
	tween.tween_property($ColorRect, "scale", Vector2(5.2, 5.5), 0.1)
	tween.tween_property($ColorRect, "scale", Vector2(5.25, 5.25), 0.1)
	
func normal_tween(tween, scale_down = true):
	if (scale_down):
		tween.tween_property($ColorRect, "scale", Vector2(4.5, 4.5), 0.1)
	tween.tween_property($ColorRect, "scale", Vector2(5, 5), 0.1)


