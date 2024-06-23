extends Node2D

signal queue_next_scene

var paycheck := preload("res://Scenes/paycheck.tscn")
var dollar_effect := preload("res://Scenes/dollar_effect.tscn")

@onready var camera = $Camera2D

var spawn_locations := {}
@onready var left_spawn_locations = $LeftSpawnLocations
@onready var right_spawn_locations = $RightSpawnLocations
@onready var top_spawn_locations = $TopSpawnLocations
@onready var bottom_spawn_locations = $BottomSpawnLocations

var rng = RandomNumberGenerator.new()

var zooming := false
var new_camera_loc := Vector2.ZERO

func _ready():
	for loc in left_spawn_locations.get_children():
		spawn_locations[loc] = Vector2.RIGHT
	for loc in right_spawn_locations.get_children():
		spawn_locations[loc] = Vector2.LEFT
	for loc in top_spawn_locations.get_children():
		spawn_locations[loc] = Vector2.DOWN
	for loc in bottom_spawn_locations.get_children():
		spawn_locations[loc] = Vector2.UP
	spawn_paycheck()

func _process(_delta):
	if zooming: 
		camera.zoom.x = move_toward(camera.zoom.x, 3, 0.1)
		camera.zoom.y = move_toward(camera.zoom.y, 3, 0.1)
		camera.position.x = move_toward(camera.global_position.x, new_camera_loc.x, 10)
		camera.position.y = move_toward(camera.global_position.y, new_camera_loc.y, 10)

func spawn_paycheck():
	var instance = paycheck.instantiate()
	
	var marker = spawn_locations.keys().pick_random()
	var direction = spawn_locations[marker]

	instance.position = marker.position
	instance.direction = direction
	instance.rotation_amt = rng.randf_range(-0.01, 0.01)
	instance.check_for_bob = randi_range(1, Global.check_chance) == 1
	instance.money_amt = rng.randi_range(Global.check_min, Global.check_max)
	instance.connect("pressed", on_paycheck_pressed)
	instance.connect("missed_bob", on_missed_bob)
	add_child(instance)

func _on_paycheck_timer_timeout():
	spawn_paycheck()

func on_paycheck_pressed(check_name, money_amt, pos):
	if check_name == "Bob":
		spawn_dollar_effect(pos, money_amt)
		Global.money += money_amt
	elif !zooming:
		initiate_loss(pos)

func on_missed_bob(pos):
	if !zooming:
		initiate_loss(pos)

func initiate_loss(pos):
	MinigameManager.minigame_complete = true
	zooming = true
	new_camera_loc = pos
	Engine.time_scale = 0.01
	Global.clicking_enabled = false
	Global.lives -= 1
	await get_tree().create_timer(0.02).timeout
	Global.queue_next_scene()

func spawn_dollar_effect(pos : Vector2, money_amt : int):
	var instance = dollar_effect.instantiate()
	instance.position = pos
	instance.update_text(money_amt)
	add_child(instance)
