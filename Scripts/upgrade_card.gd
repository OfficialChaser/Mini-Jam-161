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
		tween.tween_property($ColorRect, "scale", Vector2(0.9, 0.9), 0.1)
		if hovering:
			highlight_tween(tween)
		else:
			normal_tween(tween)
		if !card_selected:
			$ColorRect.color = Color.YELLOW
			card_selected = true
		else:
			$ColorRect.color = Color.WHITE
			card_selected = false

func highlight_tween(tween):
	tween.tween_property($ColorRect, "scale", Vector2(1.2, 1.2), 0.1)
	tween.tween_property($ColorRect, "scale", Vector2(1.1, 1.1), 0.1)
	
func normal_tween(tween, scale_down = true):
	if (scale_down):
		tween.tween_property($ColorRect, "scale", Vector2(0.9, 0.9), 0.1)
	tween.tween_property($ColorRect, "scale", Vector2(1, 1), 0.1)


