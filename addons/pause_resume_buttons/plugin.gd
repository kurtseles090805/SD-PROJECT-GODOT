@tool
extends EditorPlugin

const PLUGIN_NAME := "PauseAndResumeButtons"

const PLUGIN_ICON := preload("res://addons/pause_resume_buttons/pause_button.svg")

func _get_plugin_name() -> String:
	return PLUGIN_NAME

func _get_plugin_icon() -> Texture2D:
	return PLUGIN_ICON
