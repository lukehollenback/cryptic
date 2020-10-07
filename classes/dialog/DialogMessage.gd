class_name DialogMessage
extends Object

var _actor: String
var _actorColor: Color
var _message: String

func _init(actor: String, actorColor: Color, message: String):
	_actor = actor
	_actorColor = actorColor
	_message = message

func _to_string() -> String:
	var format = "[color=#%s]%s:[/color] %s"
	var hexColor = _actorColor.to_html()
	var formattedMsg = (format % [hexColor, _actor, _message])
	
	return formattedMsg
