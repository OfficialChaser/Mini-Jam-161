extends HSlider

var duration := 3.0
@onready var timer = $Timer
@onready var timerAnim = $"../timeranim"

var upgrade_menu = false

func _ready():
	if !get_parent().upgrade_menu:
		match Global.current_minigame:
			Global.Minigames.PAYCHECK:
				duration = 10.0
			Global.Minigames.CARNIVAL:
				duration = 5.0
	else:
		duration = 5.0
	initialize()

func _process(_delta):
	if !MinigameManager.minigame_complete:
		if(timer.time_left == 0):
			timerAnim.play("kaboom")
		elif(timer.time_left < duration * .2):
			timerAnim.play("loop5")
		elif(timer.time_left< duration * .4):
			timerAnim.play("loop4")
		elif(timer.time_left< duration * .6):
			timerAnim.play("loop3")
		elif(timer.time_left< duration * .8):
			timerAnim.play("loop2")
		else:
			timerAnim.play("loop1")
func initialize():
	timer.wait_time = duration
	max_value = duration
	value = duration
	timer.start()

func _on_timer_timeout():
	if !MinigameManager.minigame_complete:
		if !get_parent().upgrade_menu:
			match Global.current_minigame:
				Global.Minigames.PAYCHECK:
					Global.minigames_complete += 1
					Global.queue_next_scene()
				Global.Minigames.CARNIVAL:
					Global.clicking_enabled = false
					Global.lives -= 1
					Global.queue_next_scene()
		else:
			Global.new_minigame()
