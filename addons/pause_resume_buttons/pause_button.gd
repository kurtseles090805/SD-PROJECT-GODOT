@tool
@icon("res://addons/pause_resume_buttons/pause_button.svg")
class_name PauseButton
extends Button

## PauseButton
##
## Pauses the tree. When [member Button.toggle_mode] is set, the button's
## [member Button.pressed] state will match the trees [member SceneTree.paused]
## state and the button will instead [i]toggle[/i] the pause state of the tree.[br]
## NOTE: It is highly suggested to modify the [member Node.process_mode] of this
## in order for it to process with the tree's expected [member SceneTree.paused] state.

func _ready():
	if not toggle_mode:
		return
	
	var tree := get_tree()
	if tree != null:
		button_pressed = tree.paused

func _property_can_revert(property: StringName) -> bool:
	match(property):
		"text", "process_mode":
			return true
	return false

func _property_get_revert(property: StringName) -> Variant:
	match(property):
		"text":
			return "Pause"
		"process_mode":
			return PROCESS_MODE_ALWAYS
	return null

func _notification(what: int):
	if not toggle_mode:
		return
	
	match(what):
		NOTIFICATION_PAUSED:
			button_pressed = true
		NOTIFICATION_UNPAUSED:
			button_pressed = false

func _pressed():
	if toggle_mode:
		return
	
	var tree := get_tree()
	if tree != null:
		tree.paused = true

func _toggled(toggled_on: bool):
	if not toggle_mode:
		return
	
	var tree := get_tree()
	if tree != null:
		tree.paused = toggled_on
