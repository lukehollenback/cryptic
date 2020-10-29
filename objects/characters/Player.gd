extends KinematicBody2D

var deltaAggr = 0
var nearest_interactable: Interactable
var nearest_area: Interactable
var circle_vects = [
	Vector2(C.GRID_SIZE, 0),
	Vector2(C.GRID_SIZE, C.GRID_SIZE),
	Vector2(0, C.GRID_SIZE),
	Vector2(-C.GRID_SIZE, C.GRID_SIZE),
	Vector2(-C.GRID_SIZE, 0),
	Vector2(-C.GRID_SIZE, -C.GRID_SIZE),
	Vector2(0, -C.GRID_SIZE),
	Vector2(C.GRID_SIZE, -C.GRID_SIZE)
]

onready var _parent = get_parent()
onready var _interface = _parent.get_node("Interface")

func _ready():
	#
	# If present, move the player to the correct start location as per the saved game that has been
	# loaded.
	#
	position.x = G.get_prop(G.Keys.PLAYER_POS_X, position.x)
	position.y = G.get_prop(G.Keys.PLAYER_POS_Y, position.y)
	
	print("Player starting position: %s." % position)
	

func _process(_delta):
	#
	# Hide/show Gullivan's ghost as necessary.
	#
	if G.get_prop(G.Keys.STORY_CRYPT_COMPLETE, false):
		$GhostSprite.set_visible(true)
	else:
		$GhostSprite.set_visible(false)

func _physics_process(delta):
	#
	# Move the character if necessary.
	#
	var did_move = false
	
	if can_move(delta):
		if Input.is_action_pressed('move_right'):
			$Moveable.move(Directions.RIGHT)
			$GhostSprite.set_position(Vector2(-12, 0))
			$GhostSprite.set_flip_h(false)
			did_move = true
		elif Input.is_action_pressed('move_left'):
			$Moveable.move(Directions.LEFT)
			$GhostSprite.set_position(Vector2(12, 0))
			$GhostSprite.set_flip_h(true)
			did_move = true
		elif Input.is_action_pressed('move_down'):
			$Moveable.move(Directions.DOWN)
			$GhostSprite.set_position(Vector2(0, -12))
			did_move = true
		elif Input.is_action_pressed('move_up'):
			$Moveable.move(Directions.UP)
			$GhostSprite.set_position(Vector2(0, 12))
			did_move = true

	#
	# Find the nearest interactable and the nearest area.
	#
	update_nearest_interactable()
	update_nearest_area()
	
	#
	# If we did actually move...
	#
	if did_move:
		#
		# ...Tell all of the other stepables in the game to also move...
		#
		for node in get_tree().get_nodes_in_group("stepables"):
			node.step()
	
		#
		# ...And save the current state of the player.
		#
		publish_state()

#
# Intended to be called per physics processing step. Determines whether or not the player is allowed
# to move yet. Prevents constant, uncontrolled movement speed.
#
func can_move(delta):
	if _interface.has_modal(): return false
	
	deltaAggr += delta
	
	if deltaAggr >= C.MOVE_DELAY:
		deltaAggr = 0
		
		return true
	
	return false

#
# Finds the nearest interactable object and updates the related variable if said interactable object
# is within one grid square of the player.
#
func update_nearest_interactable():
	for offset in circle_vects:
		var check_pos = (position + offset)
		
		nearest_interactable = Interactable.any_at_position(get_tree(), "interactables", check_pos)
		
		if nearest_interactable != null:
			break

#
# Finds the nearest area object and updates the related variable with its name.
#
func update_nearest_area():
	var global_pos = get_global_position()
	var best_dist = 9223372036854775807
	var best_node = null
	
	for node in get_tree().get_nodes_in_group("areas"):
		var dist = global_pos.distance_to(node.get_global_position())
		
		if dist < best_dist:
			best_dist = dist
			best_node = node
	
	nearest_area = best_node
	
#
# Update the globally-known state of the player. This is what gets persisted when games get saved.
#
func publish_state():
	G.set_prop(G.Keys.PLAYER_POS_X, position.x)
	G.set_prop(G.Keys.PLAYER_POS_Y, position.y)
