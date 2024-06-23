extends Node

signal start_game
signal initiate_next_game

enum Minigames {
	PAYCHECK = 0,
	CARNIVAL = 1
}

var minigame_scenes := {
	Minigames.PAYCHECK: preload("res://Scenes/paycheck_game.tscn"),
	Minigames.CARNIVAL: preload("res://Scenes/carnival_game.tscn")
}

var minigame_names := [
	Minigames.PAYCHECK, 
	Minigames.CARNIVAL
]

var minigame_order : Array[Minigames]

var current_minigame
var current_minigame_index := 0
var previous_minigame

var money := 0
var lives := 3
var minigames_complete := 0

var clicking_enabled := true


# GAME BALANCING VALUES

# Game speed
var game_speed := 1.0

# Check game
var c_check_chance := 6
var c_check_min := 50
var c_check_max := 100
var check_chance := 6
var check_min := 100
var check_max := 1000

# Carnival game
var c_throws := 5
var c_inaccuracy_mag := 50.0
var c_carnival_money := 500
var throws := 5
var inaccuracy_mag := 50.0
var carnival_money := 500

@export var main_music := preload("res://Music/Bob MiniJam Main Theme.wav")

func _ready():
	set_minigame_order()
	current_minigame = minigame_order[current_minigame_index]
	
	await start_game
	MusicPlayer.change_music(main_music)
	get_tree().change_scene_to_packed(minigame_scenes[current_minigame])

func _process(_delta):
	pass

func queue_next_scene():
	TransitionScreen.fade_out()
	if (lives != 0):
		reset_upgrades()
		previous_minigame = current_minigame
		current_minigame_index += 1
		print(str(current_minigame_index) + "index")
		print(str(len(minigame_order)) + "len")
		if current_minigame_index < len(minigame_order):
			current_minigame = minigame_order[current_minigame_index]
		else:
			print("new set of games")
			set_minigame_order()
			current_minigame_index = 0
			current_minigame = minigame_order[current_minigame_index]
			game_speed += 0.1

		Engine.time_scale = game_speed
		clicking_enabled = true
		
		if (randi_range(1, 3) == 1):
			MinigameManager.minigame_complete = false
			get_tree().change_scene_to_file("res://Scenes/upgrade_menu.tscn")
		else:
			new_minigame()
	else:
		get_tree().change_scene_to_file("res://Scenes/game_over.tscn")

func set_minigame_order():
	if len(minigame_order) > 0:
		minigame_order.clear()
	var m_array = []
	for i in minigame_names:
		m_array.append(minigame_names[i])
	for i in range(len(m_array)):
		var game = m_array.pick_random()
		minigame_order.append(game)
		m_array.erase(game)

func new_minigame():
	MinigameManager.minigame_complete = false
	if money < 0:
		money = 0
		reset_upgrades()
	get_tree().change_scene_to_packed(minigame_scenes[current_minigame])

func reset_upgrades(all_upgrades = false):
	if all_upgrades:
		check_chance = c_check_chance
		check_min = c_check_min
		check_max = c_check_max
		throws = c_throws
		inaccuracy_mag = c_inaccuracy_mag
		carnival_money = c_carnival_money
	else:
		match current_minigame:
			Minigames.PAYCHECK:
				check_chance = c_check_chance
				check_min = c_check_min
				check_max = c_check_max
			Minigames.CARNIVAL:
				throws = c_throws
				inaccuracy_mag = c_inaccuracy_mag
				carnival_money = c_carnival_money

func increase_difficultly():
	c_inaccuracy_mag += 0.25
	
	reset_upgrades(true)
