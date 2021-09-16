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
	INV_BROKEN_VILE,
	INV_GHOSTSPEAK_AMULET,

	#
	# Story state properties (200 - 299).
	#
	STORY_WAKING_UP_COMPLETE = 200,
	STORY_TRAPPED_COMPLETE,
	STORY_SORCERY_COMPLETE,
	STORY_GHOSTS_COMPLETE,
	STORY_APOTHECARY_COMPLETE,
	STORY_CRYPT_COMPLETE,
}

const _Props = { }

#
# A static dictionary of state variables.
#
enum _StaticStateKeys {
	SKIPPED_SAVES,
}

const _StaticState = {
	_StaticStateKeys.SKIPPED_SAVES: 0
}

#
# Path of the game's save file.
#
const SaveFileName = "save.json"
const SaveFileURI = ("user://" + SaveFileName)

#
# Saves the property structure, effectively saving the game.
#
static func _save_game():
	#
	# Make sure that we should actually save. We generally skip saving a few times before
	# auto-saving to ensure that we are not hammering the file system.
	#
	_StaticState[_StaticStateKeys.SKIPPED_SAVES] += 1

	if _StaticState[_StaticStateKeys.SKIPPED_SAVES] < 10:
		return

	_StaticState[_StaticStateKeys.SKIPPED_SAVES] = 0

	#
	# Acquire a handle on the save file if we haven't already.
	#
	var f = File.new()

	handle_error(f.open(SaveFileURI, File.WRITE))

	print("Save file at %s has been opened for writing." % f.get_path())

	#
	# Write out to the file.
	#
	var data = to_json(_Props)

	f.store_string(data)

	#
	# Close the file.
	#
	f.close()

	print("Finished saving game.")

#
# Loads the saved property dictionary, effectively loading a saved game.
#
static func load_game():
	var f = File.new()

	if f.file_exists(SaveFileURI):
		f.open(SaveFileURI, File.READ)

		var data = f.get_as_text()
		var json = parse_json(data)

		print("Loaded raw save data: %s." % data)

		_Props.clear()

		for key in json.keys():
			var val = json[key]

			# NOTE: We must coerce all keys into integers. Otherwise, equality checks will
			#  possibly fail when the game attempts to lookup properties.

			_Props[int(key)] = val

		print("Loaded property dictionary: %s." % _Props)
		print("Finished loading game from %s." % (OS.get_user_data_dir() + "/" + SaveFileName))

		f.close()
	else:
		print("No save file found. New game will be loaded.")

#
# Retrieves the specified property's value from the arbitrary property store.
#
static func get_prop(key, def):
	if !_Props.has(key):
		return def

	return _Props[key]

#
# Sets the specified property's value in the arbitrary property store. We attempt to auto-save the
# game upon every single property set.
#
static func set_prop(key, val):
	_Props[key] = val

	_save_game()

	return _Props[key]

#
# Returns a debug string with all known properties and their values.
#
static func string():
	return ("%s" % _Props)

#
# Utility method for printing out a return value if it indicates failure.
#
static func handle_error(err):
	if err:
		print("Error: %s" % err)
