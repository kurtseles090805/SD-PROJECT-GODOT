@tool
extends EditorPlugin

const PLUGIN_NAME := "PauseVisibleControl"

const PLUGIN_ICON := preload("res://addons/pause_visible_control/pause_visible_control.svg")

func _get_plugin_name() -> String:
	return PLUGIN_NAME

func _get_plugin_icon() -> Texture2D:
	return PLUGIN_ICON
