extends Control

@onready var startItems = $StartItems/PanelContainer/MarginContainer/VBoxContainer.get_children()
@onready var destItems = $DestItems/PanelContainer/MarginContainer/VBoxContainer.get_children()
@onready var startScroll = $StartItems
@onready var destScroll = $DestItems

var matches = []

func _ready():
	startScroll.visible = false
	destScroll.visible = false

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
			i.show() 
		else:
			i.hide()
func _on_show_start_pressed():
	if startScroll.visible == false:
		startScroll.visible = true
	else:
		startScroll.visible = false
func _on_show_dest_pressed():
	if destScroll.visible == false:
		destScroll.visible = true
	else:
		destScroll.visible = false
