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
