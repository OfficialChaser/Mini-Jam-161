extends Node2D

@onready var s_upgrade_text = $SmallUpgradeCard/ColorRect/UpgradeText
@onready var s_cost_text = $SmallUpgradeCard/ColorRect/CostText
@onready var l_upgrade_text = $LargeUpgradeCard/ColorRect/UpgradeText
@onready var l_cost_text = $LargeUpgradeCard/ColorRect/CostText

var s_cost_amt := 500
var l_cost_amt := 1000

var s_button_on := false
var l_button_on := false

func _ready():
	match Global.current_minigame:
		Global.Minigames.PAYCHECK:
			s_upgrade_text.text = "Checks for Bob appear more"
			s_cost_text.text = "$" + str(s_cost_amt)
			l_upgrade_text.text = "Checks give more money"
			l_cost_text.text = "$" + str(l_cost_amt)
		Global.Minigames.CARNIVAL:
			s_upgrade_text.text = "2 More throws"
			s_cost_text.text = "$" + str(s_cost_amt)
			l_upgrade_text.text = "75% More accurate"
			l_cost_text.text = "$" + str(l_cost_amt)


func _on_s_button_down():
	s_button_on = !s_button_on
	if (s_button_on):
		match Global.current_minigame:
			Global.Minigames.PAYCHECK:
				Global.check_chance = 4
				Global.money -= s_cost_amt
			Global.Minigames.CARNIVAL:
				Global.throws = 7
				Global.money -= s_cost_amt
	else:
		match Global.current_minigame:
			Global.Minigames.PAYCHECK:
				Global.check_chance = Global.c_check_chance
				Global.money += s_cost_amt
			Global.Minigames.CARNIVAL:
				Global.throws = Global.c_throws
				Global.money += s_cost_amt


func _on_l_button_down():
	l_button_on = !l_button_on
	if (l_button_on):
		match Global.current_minigame:
			Global.Minigames.PAYCHECK:
				Global.check_min = 100
				Global.check_max = 300
				Global.money -= l_cost_amt
			Global.Minigames.CARNIVAL:
				Global.inaccuracy_mag *= .25
				Global.money -= l_cost_amt
	else:
		match Global.current_minigame:
			Global.Minigames.PAYCHECK:
				Global.check_min = Global.c_check_min
				Global.check_max = Global.c_check_max
				Global.money += l_cost_amt
			Global.Minigames.CARNIVAL:
				Global.inaccuracy_mag = Global.c_inaccuracy_mag
				Global.money += l_cost_amt
