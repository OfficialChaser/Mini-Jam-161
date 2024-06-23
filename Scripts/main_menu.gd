extends Control

func _on_play_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/carnival_game.tscn")
	Global.start_game.emit()
