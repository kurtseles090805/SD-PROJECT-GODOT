extends TileMap


@export var grid_size: Vector2 = Vector2(10, 10)  # Grid dimensions (columns, rows)
@export var cell_size: Vector2 = Vector2(64, 64)  # Size of each cell in pixels

func _ready() -> void:
	draw_grid()

func draw_grid() -> void:
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			var rect = Rect2(Vector2(x, y) * cell_size, cell_size)
			draw_rect(rect, Color(1, 1, 1, 0.2), false)
