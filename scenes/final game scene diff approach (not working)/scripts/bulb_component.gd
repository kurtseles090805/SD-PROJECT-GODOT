extends BaseComponent
class_name BulbComponent

#@export var resistance := 500.0  # Example resistance value for a bulb

func _ready():
	component_type = "bulb"
	# Add any bulb-specific initialization here
