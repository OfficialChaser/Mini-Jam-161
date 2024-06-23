extends CanvasLayer

signal animation_finished

@onready var anim_sprite = $AnimatedSprite2D

func _ready():
	fade_in()

func _process(_delta):
	pass

func fade_in():
	anim_sprite.visible = true
	anim_sprite.play("FadeIn")
	await anim_sprite.animation_finished
	anim_sprite.visible = false


func _on_animated_finished():
	animation_finished.emit()
