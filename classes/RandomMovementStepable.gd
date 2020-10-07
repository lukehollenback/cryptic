#
# Randomly moves the parent via it's "Moveable" child node every game step.
#
class_name RandomMovementStepable
extends Stepable

onready var _moveable = _parent.get_node("Moveable")

export(int) var movement_chances = 50 # The number of chances out of a hundred that the node has to
									# actually move per game step.

func _ready():
	add_to_group("stepables")

func get_class():
	return "RandomMovementStepable"

#
# Called when a game step occurs.
#
func step():
	var rand = (randi() % 100)
	
	if rand <= movement_chances:
		var dir = (randi() % Directions.Count)
		
		_moveable.move(dir)
