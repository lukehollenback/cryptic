extends Camera2D

func _ready():
	var err = get_tree().root.connect("size_changed", self, "_on_viewport_size_changed")
	if err:
		print(err)
	
func _on_viewport_size_changed():
	var vp = get_viewport_rect()
	
	print ("Viewport size changed (rect: %s)." % vp)
