extends Node2D

signal pressed(check_name, money_amt, pos)
signal missed_bob(pos)

@onready var name_label = $SizeNode/NameLabel
@onready var money_label = $SizeNode/MoneyLabel
@onready var highlight = $SizeNode/Sprite2D/Highlight
@onready var size_node = $SizeNode


var speed = randf_range(150.0, 300.0)
var direction : Vector2
var rotation_amt : float

var check_for_bob : bool
var check_name := "Bob"
var money_amt : int

@export var npc_names : Array[String]

var hovering := false

var in_view := false

func _ready():
	if !check_for_bob:
		check_name = npc_names.pick_random()
	else:
		z_index = 5
		process_priority = 1
	name_label.text = check_name
	money_label.text = "$" + str(money_amt)

func _process(delta):
	translate(direction * speed * delta)
	rotate(rotation_amt)
	if (!Global.clicking_enabled):
		var tween = create_tween()
		normal_tween(tween, false, true)


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
		tween.tween_property(size_node, "scale", Vector2(0.9, 0.9), 0.1)
		if hovering:
			highlight_tween(tween)
		else:
			normal_tween(tween)
		await get_tree().create_timer(0.2).timeout
		pressed.emit(name_label.text, money_amt, position)
		if (check_name != "Bob"):
			z_index = 10
			await get_tree().create_timer(0.2).timeout
		queue_free()

func highlight_tween(tween):
	tween.tween_property(size_node, "scale", Vector2(1.2, 1.2), 0.1)
	highlight.color = Color(Color.YELLOW, 0.1)
	tween.tween_property(size_node, "scale", Vector2(1.2, 1.1), 0.1)
	
func normal_tween(tween, scale_down = true, red = false):
	if (scale_down):
		tween.tween_property(size_node, "scale", Vector2(0.9, 0.9), 0.1)
	tween.tween_property(size_node, "scale", Vector2(1, 1), 0.1)
	if (red):
		highlight.color = Color(Color.RED, 0.2)
	else:
		highlight.color = Color(Color.WHITE, 0.1)


func _on_visible_on_screen_notifier_2d_screen_entered():
	in_view = true

func _on_visible_on_screen_notifier_2d_screen_exited():
	in_view = false
	if check_name == "Bob":
		missed_bob.emit(position)
		await get_tree().create_timer(0.2).timeout
	queue_free()
