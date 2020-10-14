class_name Interactable
extends Area2D

export(bool) var can_move # Whether or not the object should update it's bounding box after initialization.
export(bool) var is_child = true # Whether or not the object is a child of a greater node scene (as opposed to being its root).
export(String) var object_name # The object's name during interaction.
export(String) var action_phrase # The object's action phrase for display on the interface.

onready var _parent = get_parent()

var _scaled_extents: Vector2
var _scaled_position: Vector2
var _x_start: float
var _y_start: float
var _x_end: float
var _y_end: float

func _ready():
	update_bounding_box()

func get_class():
	return "Interactable"

func destroy():
	#
	# First remove the interactable from all groups that it belongs to. We do this to prevent weird
	# race conditions with invalid instances due to the way this game uses groups for signaling.
	#
	for group in get_groups():
		remove_from_group(group)
	
	#
	# Queue the appropriate element to be freed from the queue and thus destroyed.
	#
	if is_child:
		_parent.queue_free()
	else:
		queue_free()

#
# Implemented by interactables for execution when the "interact" action is executed.
#
func interact(_interface: Node, _player: Node):
	print("Unimplemented interact method.")
	
#
# Recalculates the bounding box used by at_position(...). Is called once by _ready(), and then only
# ever called again if can_move is set to true.
#
func update_bounding_box():
	var parent_x = _parent.get_position().x
	var parent_y = _parent.get_position().y
	
	_scaled_extents = ($CollisionShape2D.get_shape().get_extents() * scale)
	_scaled_position = ($CollisionShape2D.get_position() * scale)
	_x_start = (parent_x + position.x + (_scaled_position.x - _scaled_extents.x))
	_y_start = (parent_y + position.y + (_scaled_position.y - _scaled_extents.y))
	_x_end = (parent_x + position.x + (_scaled_position.x + _scaled_extents.x))
	_y_end = (parent_y + position.y + (_scaled_position.y + _scaled_extents.y))

#
# Determines if the provided coordinate is within the bounds of this object.
#
func at_position(pos: Vector2) -> bool:
	if can_move:
		update_bounding_box()
	
	if (pos.x >= _x_start && pos.x < _x_end) && (pos.y >= _y_start && pos.y < _y_end):
		return true
	
	return false

#
# Determines if provided coordinate is within the bounds of any of the InteractableNode2D instances
# in the specified group.
#
static func any_at_position(tree: SceneTree, group: String, pos: Vector2) -> Interactable:
	for node in tree.get_nodes_in_group(group):
		if node.get_class() != "Interactable":
			print("Node is in group \"%s\" was not of type Interactable (was %s)." % [group, node.get_class()])
			continue
		
		if node.at_position(pos):
			return node
	
	return null
