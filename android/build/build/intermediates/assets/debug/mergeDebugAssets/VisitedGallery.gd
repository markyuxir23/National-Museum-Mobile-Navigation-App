extends PanelContainer

@onready var galleryName = %GalleryName
@onready var hallName = %Hallname
@onready var properties = [galleryName, hallName]

func display(gallery:Dictionary):
	for key in gallery:
		if key == null:
			gallery[key] = ""
		for item in properties:
			if key.contains((item.name).to_lower()):
				item.text = str(gallery[key])
