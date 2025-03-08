extends Node2D  # Works for both draggable object & droppable area

var dragging = false
var mouse_offset = Vector2.ZERO
var original_position = Vector2.ZERO  # Store original position
var droppable_zone = null  # Reference to the droppable area

@onready var sprite = $Sprite2D  # Object's visual representation
@onready var area = $Area2D  # Collision detection

func _ready():
	original_position = position  # Store the initial position
	if is_in_group("droppable"):
		return  # Droppable areas don't need dragging logic

func _process(_delta):
	if dragging:
		position = get_global_mouse_position() + mouse_offset

func _input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			mouse_offset = position - get_global_mouse_position()
		else:
			dragging = false
			if droppable_zone:
				position = droppable_zone.global_position  # ✅ Snap to droppable area
				droppable_zone.set_texture(sprite.texture)  # ✅ Transfer texture
			else:
				position = original_position  # ✅ Return to original position

# Called when a draggable object enters a droppable area
func _on_area_2d_area_entered(area):
	if area.is_in_group("droppable"):
		droppable_zone = area.get_parent()  # Reference the droppable Node2D

# Called when a draggable object exits a droppable area
func _on_area_2d_area_exited(area):
	if area.is_in_group("droppable") and droppable_zone == area.get_parent():
		droppable_zone = null  # Clear the reference

# Function for droppable area to set texture
func set_texture(texture: Texture2D):
	if sprite:
		sprite.texture = texture  # ✅ Assign the dropped texture
