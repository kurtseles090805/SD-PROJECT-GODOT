@tool
@icon("res://addons/pause_visible_control/pause_visible_control.svg")
class_name PauseVisibleControl
extends Control

## PauseVisibleControl
## 
## A [Control] that syncs it's [member Control.visible]ity with the current tree's
## [member SceneTree.paused] state.

## Also sync the [member Control.visible]ity state in editor.
@export var in_editor := false

func _ready():
	if not in_editor and Engine.is_editor_hint():
		return
	
	var tree := get_tree()
	visible = tree != null and tree.paused

func _property_can_revert(property: StringName) -> bool:
	match(property):
		"process_mode":
			return true
	return false

func _property_get_revert(property: StringName) -> Variant:
	match(property):
		"process_mode":
			return PROCESS_MODE_ALWAYS
	return null

func _notification(what: int):
	if not in_editor and Engine.is_editor_hint():
		return
	
	match(what):
		NOTIFICATION_PAUSED:
			show()
		NOTIFICATION_UNPAUSED:
			hide()
