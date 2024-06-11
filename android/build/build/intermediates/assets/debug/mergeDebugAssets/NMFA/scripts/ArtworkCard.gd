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

var auth = Firebase.Auth.auth
var recomdbRef = Firebase.Database.get_database_reference("userData")
var newPath = Firebase.Database.get_database_reference("userData/userRecommendations/" + auth.localid)
var recomsByUserPath = Firebase.Database.get_database_reference("userData/recomsByUser")

func _ready():
	artworkPanel.show()
	newPath.new_data_update.connect(getDocument)
	newPath.patch_data_update.connect(getDocument)
	newPath.delete_data_update.connect(getDocument)

	var userRecommendations = {}
	recomdbRef.push(userRecommendations)

func _on_info_button_pressed():
	var index = 0
	var selectedArtwork = []
	artworkPanel.hide()
	
	for key in Globals.currentArtworks[0]:
		if infobutton.name == str(index):
			selectedArtwork.append(Globals.currentArtworks[0][key])
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

func _on_recommend_pressed():
	var auth = Firebase.Auth.auth
	var recomEntry = {
		"Title": title.text,
		"Artist": artist.text,
		"Date": date.text,
		"Place": place.text,
		"Type": type.text,
	}
	newPath.update(title.text, recomEntry)
	%Recommend.hide()
	%RemoveRecom.show()
	
func _on_remove_recom_pressed():
	print("removepressed")
	%Recommend.button_pressed = false
	var auth = Firebase.Auth.auth
	var recomEntry = {
		"Title": title.text,
		"Artist": artist.text,
		"Date": date.text,
		"Place": place.text,
		"Type": type.text,
	}
	newPath.delete("/" + title.text + "/")
	%Recommend.show()
	%RemoveRecom.hide()

func getDocument(document):
	var auth = Firebase.Auth.auth
	print("NEW_DATA: ", document)
	var fullData = newPath.get_data()
