extends Sprite2D

func _ready():
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(0, 0), 1)
	await tween.finished
	queue_free()
