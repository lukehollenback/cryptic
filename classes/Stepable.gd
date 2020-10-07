#
# Provides common interface for reacting to a game step – which occurs when the player actually
# moves.
#
class_name Stepable
extends Node

onready var _parent = get_parent()

func get_class():
	return "Stepable"

#
# Called when a game step occurs.
#
func step():
	print("No implementation for this stepable.")
