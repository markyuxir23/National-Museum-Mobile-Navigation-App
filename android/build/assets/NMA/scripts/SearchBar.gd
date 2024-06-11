extends Control

@onready var startItems = %MarginContainer.get_child(0).get_children()
@onready var destItems = %Destinations_NMA.get_children()
@onready var startScroll = $StartItems
@onready var destScroll = $DestItems

var matches = []

func _ready():
	startScroll.hide()
	destScroll.hide()

func _input(event):
	if event is InputEventScreenDrag or event is InputEventScreenTouch:
		var touch_pos = get_local_mouse_position()
		if Rect2(Vector2.ZERO, size).has_point(touch_pos) == true:
			if destScroll.visible == true or startScroll.visible == true:
				GlobalsNMA.cannot_pan = true
		elif Rect2(Vector2.ZERO, size).has_point(touch_pos) == false:
			GlobalsNMA.cannot_pan = false
			
func _gui_input(event):
	if startScroll.visible == true:
		startScroll.size.y = 264
	elif startScroll.visible == false:
		startScroll.size.y = 0
	
	if destScroll.visible == true:
		destScroll.size.y = 264
	elif destScroll.visible == false:
		destScroll.size.y = 0
	
	if startScroll.visible == false && destScroll.visible == false:
		startScroll.size.y = 0
		destScroll.size.y = 0
		size.y = 160
	
	if startScroll.visible == true or destScroll.visible == true:
		size.y = 384

func _on_start_text_changed(new_text):
	new_text = new_text.to_lower()
	if new_text == "":
		startScroll.visible = false
		return

	matches.clear()
	startScroll.visible = true
	for i in startItems:
		if new_text in i.text.to_lower():
			matches.append(i)
	for i in startItems:
		if i in matches:
			i.show() 
		else:
			i.hide()

func _on_destination_text_changed(new_text):
	new_text = new_text.to_lower()
	if new_text == "":
		destScroll.visible = false
		return

	matches.clear()
	destScroll.visible = true
	for i in destItems:
		if new_text in i.text.to_lower():
			matches.append(i)
	for i in destItems:
		if i in matches:
			%ETA.hide()
			i.show()
		else:
			%ETA.show()
			i.hide()

func _on_show_start_pressed():
	if destScroll.visible == true:
		destScroll.hide()
		if startScroll.visible == false:
			%ETA.hide()
			startScroll.show()
		else:
			%ETA.show()
			startScroll.hide()
	else:
		if startScroll.visible == false:
			%ETA.hide()
			startScroll.show()
		else:
			%ETA.show()
			startScroll.hide()

func _on_show_dest_pressed():
	if startScroll.visible == true:
		startScroll.hide()
		if destScroll.visible == false:
			%ETA.hide()
			destScroll.show()
		else:
			%ETA.show()
			destScroll.hide()
	else:
		if destScroll.visible == false:
			%ETA.hide()
			destScroll.show()
		else:
			%ETA.show()
			destScroll.hide()
