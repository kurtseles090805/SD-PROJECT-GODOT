extends CanvasLayer

signal on_transition_finished

@onready var color_rect = $ColorRect
@onready var animation_player = $AnimationPlayer

func _ready():
	color_rect.visible = false
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name):
	if anim_name == "FadeToBlack":
		on_transition_finished.emit()
		animation_player.play("FadeToNormal")
	elif anim_name == "FadeToNormal":
		color_rect.visible = false

func _transition():
	color_rect.visible = true # Show it before fading
	animation_player.play("FadeToBlack")
