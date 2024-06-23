extends Control
@onready var bobAnim = $AnimatedSprite2D
@export var sadThresh:int

func ready():
	Global.clicking_enabled = true
	if(Global.money < sadThresh):
		bobAnim.play("weep")
	else:
		bobAnim.play("idle")

func _process(_delta):
	Engine.time_scale = 1
	$MoneyLabel.text = "$" + str(Global.money)
	Input.set_custom_mouse_cursor(null)

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
