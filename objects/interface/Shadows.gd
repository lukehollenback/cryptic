extends CanvasLayer

func _ready():
	for node in get_children():
		if node.get_class() == "ColorRect":
			var a = node.color.a
			var c = Colors.BLACK
			
			c.a = a
			
			node.color = c
