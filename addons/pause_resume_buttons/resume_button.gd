@tool
@icon("res://addons/pause_resume_buttons/resume_button.svg")
class_name ResumeButton
extends Button

## ResumeButton
## 
## Resumes (unpauses) the tree. When [member Button.toggle_mode] is set,
## the button's [member Button.pressed] will inversely match the trees [member SceneTree.paused]
## state and the button will instead [i]toggle[/i] the pause state of the tree.
## NOTE: It is highly suggested to modify the [member Button.process_mode]
## of this in order for it to process with the tree's expected [member SceneTree.paused] state.

func _ready():
	if not toggle_mode:
		return
	
	var tree := get_tree()
	if tree != null:
		button_pressed = not tree.paused

func _property_can_revert(property: StringName) -> bool:
	match(property):
		"text", "process_mode":
			return true
	return false

func _property_get_revert(property: StringName) -> Variant:
	match(property):
		"text":
			return "Resume"
		"process_mode":
			return PROCESS_MODE_ALWAYS
	return null

func _notification(what: int):
	if not toggle_mode:
		return
	
	match(what):
		NOTIFICATION_PAUSED:
			button_pressed = false
		NOTIFICATION_UNPAUSED:
			button_pressed = true

func _pressed():
	if toggle_mode:
		return
	
	var tree := get_tree()
	if tree != null:
		tree.paused = false

func _toggled(toggled_on: bool):
	if not toggle_mode:
		return
	
	var tree := get_tree()
	if tree != null:
		tree.paused = not toggled_on
