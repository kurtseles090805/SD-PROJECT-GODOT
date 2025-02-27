extends Node

var timer = Timer.new()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Global Autoload Ready")

	add_child(timer)
	timer.start(3)
