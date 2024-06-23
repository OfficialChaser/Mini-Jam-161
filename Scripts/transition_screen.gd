extends Control

signal animation_finished

@onready var anim_sprite = $AnimatedSprite2D

func _ready():
	fade_in()

func fade_full():
	fade_out()
	bob()
	fade_in()

func fade_out():
	anim_sprite.visible = true
	anim_sprite.play("FadeOut")
	await anim_sprite.animation_finished

func bob():
	anim_sprite.visible = true
	anim_sprite.play("bob")
	await anim_sprite.animation_finished

func fade_in():
	anim_sprite.visible = true
	anim_sprite.play("FadeIn")
	await anim_sprite.animation_finished
	anim_sprite.visible = false


func _on_animated_finished():
	animation_finished.emit()
