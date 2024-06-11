extends ScrollContainer

#func _input(event):
	#if visible:
		#if event is InputEventScreenDrag or event is InputEventScreenTouch:
			#var touch_pos = get_local_mouse_position()
			#
			#if Rect2(Vector2.ZERO, size).has_point(touch_pos) == true:
				#Globals.cannot_pan = true
			#elif Rect2(Vector2.ZERO, size).has_point(touch_pos) == false:
				#Globals.cannot_pan = false
	#else:
		#Globals.cannot_pan = false
