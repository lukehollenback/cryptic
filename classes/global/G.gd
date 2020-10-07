#
# A global singleton used to store the entire persisted game state. Necessary in order to save and
# load the game between sessions. Includes state members such as player health, player location,
# player inventory, story status, and so on.
#
class_name G
extends Object

#
# Constant keys for properties.
#
# NOTE: We intentionally leave numeric space between categories in case we need to add some more
#  more keys to a specific section in the future.
#
enum Keys {
	#
	# Player state properties (0 - 99).
	#
	PLAYER_POS_X = 0,
	PLAYER_POS_Y,
	
	#
	# Inventory (100 - 199)
	#
	INV_HOUSE_KEY = 100,
	INV_HALL_KEY,
	INV_GULLIVANS_JOURNAL,
	
	#
	# Story state properties (200 - 299).
	#
	STORY_WAKING_UP_COMPLETE = 200,
	STORY_TRAPPED_COMPLETE,
	STORY_SORCERY_COMPLETE
}

const _props = { }

#
# Retrieves the specified property's value from the arbitrary property store.
#
static func get_prop(key, def):
	if !_props.has(key):
		return def
	
	return _props[key]

#
# Sets the specified property's value in the arbitrary property store.
#
static func set_prop(key, val):
	_props[key] = val

	return _props[key]
