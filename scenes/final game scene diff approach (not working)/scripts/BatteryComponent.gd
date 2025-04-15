extends BaseComponent
class_name BatteryComponent

@export var voltage := 9.0
@export var positive_terminal_idx := 0  # 0 for Terminal1, 1 for Terminal2

func _ready():
	component_type = "battery"
	# Visual terminal indicators
	$Terminal1.modulate = Color.RED if positive_terminal_idx == 0 else Color.BLACK
	$Terminal2.modulate = Color.RED if positive_terminal_idx == 1 else Color.BLACK

func is_terminal_positive(terminal_idx: int) -> bool:
	return terminal_idx == positive_terminal_idx

func get_voltage_at_terminal(terminal_idx: int) -> float:
	return voltage if terminal_idx == positive_terminal_idx else -voltage
