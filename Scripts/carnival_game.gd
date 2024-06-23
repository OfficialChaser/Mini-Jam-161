extends Node2D

signal game_won

var minigame_status = "running"

var ball = preload("res://Scenes/ball.tscn")

var can_warp_mouse = true
@onready var move_mouse_timer = $MoveMouseTimer

var new_location : Vector2

var bottles_hit := 0
var balls_left := 5

@onready var throws_label = $CanvasLayer/ThrowsLabel

func _ready():
	TransitionScreen.fade_in()	
	$CrosshairSprite.global_position = get_global_mouse_position()
	balls_left = Global.throws
	new_location = get_global_mouse_position() + random_point()

func _process(_delta):
	throws_label.text = "Throws left: " + str(balls_left)
	if (minigame_status == "running"):
		if move_mouse_timer.is_stopped():
			move_mouse_timer.start()
			new_location = get_global_mouse_position() + random_point()
			var tween = create_tween()
			tween.tween_property($CrosshairSprite, "position", new_location, 0.2)
		
		if bottles_hit == 3:
			Global.money += Global.carnival_money
			Global.minigames_complete += 1
			minigame_status = "won"
			
		elif balls_left == 0:
			minigame_status = "lost"
			
	elif (minigame_status == "won"):
		game_won.emit()
		MinigameManager.minigame_complete = true
		await get_tree().create_timer(2).timeout
		Global.queue_next_scene()

	elif (minigame_status == "lost"):
		MinigameManager.minigame_complete = true
		$CanvasLayer/ThrowsLabel/ColorRect.visible = true
		throws_label.add_theme_color_override("font_color",Color.DARK_RED) 
		await get_tree().create_timer(3).timeout
		Global.queue_next_scene()

func random_point() -> Vector2:
	return Vector2 (
		randf_range(-Global.inaccuracy_mag, Global.inaccuracy_mag + 1), 
		randf_range(-Global.inaccuracy_mag, Global.inaccuracy_mag + 1)
	)

func _input(event):
	if event.is_action_pressed("left_click") and Global.clicking_enabled:
		var instance = ball.instantiate()
		instance.position = $CrosshairSprite.global_position
		add_child(instance)
		balls_left -= 1

func _on_bottle_hit():
	bottles_hit += 1
