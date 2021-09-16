class_name Colors
extends Object

const BLACK = Color("#000000")
const WHITE = Color("#feffff")
const GRAY = Color("#808080")
const YELLOW = Color("#ffe228")
const ORANGE = Color("#c96628")
const RED = Color("#ff0000")
const GREEN = Color("#009900")
const BLUE = Color("#192ee8")
const CYAN = Color("#5de0e2")
const PINK = Color("#c11f52")

const LOOKUP = {
	"black": BLACK,
	"white": WHITE,
	"gray": GRAY,
	"yellow": YELLOW,
	"orange": ORANGE,
	"red": RED,
	"green": GREEN,
	"blue": BLUE,
	"cyan": CYAN,
	"pink": PINK
}

#
# Finds the Color instance representing the color with the provided friendly name.
#
static func lookup_color(name: String) -> Color:
	return LOOKUP[name]

#
# Swaps out basic colors in the provided BBCode with ones supported by a RichTextLabel's BBCode.
#
static func parse_bbcode(bbcode: String) -> String:
	for key in LOOKUP:
		var find = ("[color=" + key + "]")
		var replace = ("[color=#" + LOOKUP[key].to_html() + "]")

		bbcode = bbcode.replacen(find, replace)

		find = ("[" + key + "]")

		bbcode = bbcode.replacen(find, replace)

	return bbcode
