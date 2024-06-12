extends MarginContainer

@onready var infobutton = %InfoButton
@onready var artworkPanel = %Artwork
@onready var xButton = %Button
@onready var title = %Title
@onready var artist = %Artist
@onready var date = %Date
@onready var place = %Place
@onready var type = %Type
@onready var properties = [title, artist, date, place, type]
@onready var localRecoms: Dictionary

func _ready():
	artworkPanel.show()

func _on_info_button_pressed():
	var index = 0
	var selectedArtwork = []
	artworkPanel.hide()
	
	for key in GlobalsNMA.currentArtworks[0]:
		if infobutton.name == str(index):
			selectedArtwork.append(GlobalsNMA.currentArtworks[0][key])
			break
		index += 1
	for key in selectedArtwork[0]:
		for item in properties:
			if key == null:
				selectedArtwork[key] = ""
			if str(key).to_lower().contains(str(item.name).to_lower()):
				item.text = str(selectedArtwork[0][key])

func _on_button_pressed():
	artworkPanel.show()
