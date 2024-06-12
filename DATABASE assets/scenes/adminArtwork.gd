extends PanelContainer

@onready var title = %Title
@onready var artist = %Artist
@onready var date = %Date
@onready var place = %Place
@onready var type = %Type
@onready var properties = [title, artist, date, place,type]

func display(art:Dictionary):
	for key in art:
		if key == null:
			art[key] = ""
		for item in properties:
			if str(key).contains((item.name).to_lower()):
				item.text = str(art[key])

func search(text: String):
	for p in properties:
		if ((p.text).to_lower()).contains(text):
			return true

func _on_delete_pressed():
	%Warning.text = "Are you sure you want to delete " + title.text + "?"
	%WarningContainer.show()
	%EditDeleteButtons.hide()
	%Labels.hide()

func _on_no_pressed():
	%WarningContainer.hide()
	%EditDeleteButtons.show()
	%Labels.show()

func _on_edit_pressed():
	%Labels.hide()
	%EditDeleteButtons.hide()
	var labelsArray = %Labels.get_children()
	for property in labelsArray:
		if property == null:
			property = ""
		for lines in %LabelLines.get_children():
			if str(lines.name).to_lower().contains(str(property.name).to_lower()):
				lines.text = property.text
	%LabelLines.show()
	%SaveCancelButtons.show()

func _on_cancel_pressed():
	%Labels.show()
	%EditDeleteButtons.show()
	%LabelLines.hide()
	%SaveCancelButtons.hide()
