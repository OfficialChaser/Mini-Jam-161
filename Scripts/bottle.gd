extends Node2D

signal bottle_hit

var clickable := false

func end_sequence():
	$AnimationPlayer.play("crack")

func _input(event):
	if event.is_action_pressed("left_click") and clickable and Global.clicking_enabled:
		bottle_hit.emit()
		end_sequence()

func _on_bottle_area_entered(area):
	if area.name == "CrosshairArea":
		clickable = true


func _on_bottle_area_exited(area):
	if area.name == "CrosshairArea":
		clickable = false
