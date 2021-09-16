tool
class_name OutlinedColorRect
extends ColorRect

export(bool) var can_move # Whether or not the object should update it's bounding box after initialization.
export(Color) var outline_color # The color to draw the outline in.

var rect: Rect2

func get_class():
	return "OutlinedColorRect"

func _ready():
	update_rect()

func _draw():
	if can_move:
		update_rect()

	draw_rect(rect, outline_color, false, 1, false)

func update_rect():
	# NOTE: We have to do some wonky stuff here because of how Godot references pixels when it
	#  talks to OpenGL. Maybe one day we can switch this back to be 0s instead of 0.5s.

	rect = Rect2(Vector2(0.5, 0.5), get_size())
