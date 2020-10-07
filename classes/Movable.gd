#
# Movement and collision handler node that can be appended to KinematicBody2D nodes via composition.
# Call into this node w/movement actions to have it move its parent.
#
class_name Moveable
extends Node

onready var _parent = get_parent()
onready var _sprite = _parent.get_node("Sprite")

func get_class():
	return "Moveable"

func move(action):
	var dest_x = _parent.get_position().x
	var dest_y = _parent.get_position().y
	
	if action == Directions.RIGHT:
		dest_x += C.GRID_SIZE
		
		if _sprite != null:
			_sprite.flip_h = false
	elif action == Directions.LEFT:
		dest_x -= C.GRID_SIZE
		
		if _sprite != null:
			_sprite.flip_h = true
	elif action == Directions.DOWN:
		dest_y += C.GRID_SIZE
	elif action == Directions.UP:
		dest_y -= C.GRID_SIZE
		
	if dest_x != _parent.get_position().x || dest_y != _parent.get_position().y:
		if Interactable.any_at_position(get_tree(), "walls", Vector2(dest_x, dest_y)):
			dest_x = _parent.get_position().x
			dest_y = _parent.get_position().y
			
	if dest_x != _parent.get_position().x || dest_y != _parent.get_position().y:
		_parent.set_position(Vector2(dest_x, dest_y))
