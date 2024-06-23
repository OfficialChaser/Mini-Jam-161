extends Node2D

@onready var label_container = $LabelContainer
@onready var effect_timer = $EffectTimer

# Called when the node enters the scene tree for the first time.
func _ready():
	label_container.scale = Vector2.ZERO
	var tween = create_tween()
	tween.tween_property(label_container, "scale", Vector2(1.5, 1.5), 0.2)
	tween.tween_property(label_container, "scale", Vector2(1.25, 1.25), 0.2)

func update_text(dollar_amt : int):
	$LabelContainer/Label.text = "$" + str(dollar_amt)
	$LabelContainer/Label2.text = $LabelContainer/Label.text 

func _on_effect_timer_timeout():
	var tween = create_tween()
	tween.tween_property(label_container, "modulate", Color.TRANSPARENT, 0.5)
	await tween.finished
	queue_free()
