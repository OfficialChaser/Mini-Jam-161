extends Control

@onready var lives_container = $LivesContainer
@onready var money_label = $MoneyLabel

var index_to_disable := 2
var lives_showing := Global.lives

@export var upgrade_menu = false

var win_anim_played := false


func _ready():
	for i in range(Global.lives):
		lives_container.get_child(i).modulate = Color.WHITE
		lives_container.get_child(i).get_node("AnimatedSprite2D").play("default")
	for i in range(3 - Global.lives):
		lives_container.get_child(i).modulate = Color.WHITE
		lives_container.get_child(2 - i).get_node("AnimatedSprite2D").play("death")

func _process(_delta):
	money_label.text = "$" + str(Global.money)
	if (!Global.money >= 0):
		money_label.modulate = Color.RED
	else:
		money_label.modulate = Color.WHITE
	

func update_lives():
	print("test")
	for i in range(3):
		lives_container.get_child(i).get_node("AnimatedSprite2D").play("death")
	for i in range(Global.lives):
		lives_container.get_child(i).get_node("AnimatedSprite2D").play("default")


func _on_carnival_game_won():
	if !win_anim_played:
		$winscreen.play("win")
		win_anim_played = true
