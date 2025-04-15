extends Control

# Signal that the component was dropped into the zone
signal component_dropped(component)

# Store the current component that was dropped into this zone
var current_component: Node = null

# Called when a component is dropped on this drop zone
func set_component(component: Node) -> void:
	if current_component:
		return  # If a component is already dropped here, ignore further drops.
		
	current_component = component
	emit_signal("component_dropped", component)  # Emit the signal to notify the main controller.
	component.light_up()  # Optionally light up the component immediately when dropped

# Optional: Clear the drop zone (reset to initial state)
func clear_zone() -> void:
	if current_component:
		current_component.reset_component()  # Reset component's visual state
		current_component = null  # Clear the component from the drop zone
