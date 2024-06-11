extends Control

@onready var artContainer = %ArtworkContainer
@onready var galleryLabel = %GalleryLabel
@onready var hallLabel = %HallnameLabel
@onready var infoLabel = %InfoLabel
@onready var galleryData = StaticDatabase.gallery_data
@onready var currentArts: Array[Dictionary]
@onready var matches = []

@export var artworkScene: PackedScene
@export var _2FScene: PackedScene
@export var _3FScene: PackedScene
@export var _4FScene: PackedScene

var auth = Firebase.Auth.auth
var recomdbRef = Firebase.Database.get_database_reference("userData")
var newPath = Firebase.Database.get_database_reference("userData/userVisited/" + auth.localid)

var restrictDB = Firebase.Database.get_database_reference("restrictedData/Galleries/")
var restrictData: Dictionary

var isRestricted = false

func _ready():
	hallLabel.text = ""
	infoLabel.text = ""
	galleryLabel.text = Globals.gallery_name
	for gallery in galleryData:
		if Globals.gallery_name == gallery:
			for key in galleryData[gallery]:
				if hallLabel.text == "":
					hallLabel.text = str(galleryData[gallery][key]["gallery_hallname"])
					infoLabel.text = str(galleryData[gallery][key]["gallery_info"])
				currentArts.append(galleryData[gallery][key])
	
	getCurrentArtworks()

	newPath.new_data_update.connect(getDocument)
	newPath.patch_data_update.connect(getDocument)
	newPath.delete_data_update.connect(getDocument)

	restrictDB.update("dummy", {0:0})
	
	restrictDB.new_data_update.connect(updateData)
	restrictDB.patch_data_update.connect(updateData)
	restrictDB.delete_data_update.connect(updateData)

func updateData(document):
	restrictData = restrictDB.get_data()
	if restrictData.keys().has(galleryLabel.text):
		isRestricted = true
		print(isRestricted)
		getCurrentArtworks()

func getCurrentArtworks():
	if artContainer.get_children().size() != 0 or null:
		for i in artContainer.get_children():
			artContainer.remove_child(i)
	
	if isRestricted == true:
		currentArts.clear()
	
	if currentArts.size() == 0:
		var label = Label.new()
		artContainer.add_child(label)
		label.text = "TEMPORARILY CLOSED"
		label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
		label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	elif currentArts.size() > 0:
		for artwork in currentArts:
			var art = artworkScene.instantiate()
			artContainer.add_child(art)
			art.display(artwork)

func _on_return_button_pressed():
	_on_see_on_map_pressed()

func _on_search_bar_text_changed(new_text):
	new_text = new_text.to_lower()
	if new_text == "" or new_text == null or new_text == " ":
		getCurrentArtworks()
		for i in artContainer.get_children():
			i.show()
	
	else:
		matches.clear()
		for i in artContainer.get_children():
			if i.search(new_text) == true:
				matches.append(i)

		for i in artContainer.get_children():
			if i in matches:
				i.show() 
			else:
				i.hide()

func _on_see_on_map_pressed():
	Globals.interfloor_destination = null
	Globals.interfloor_origin = null
	Globals.see_on_map_gallery = null
	var galleryGroup = Globals.checkGroup(galleryLabel.text)
	if galleryGroup == "2F":
		get_tree().change_scene_to_file("res://NMFA/scenes/NMFA scenes/NMFA-2F.tscn")
	if galleryGroup == "3F":
		get_tree().change_scene_to_file("res://NMFA/scenes/NMFA scenes/NMFA-3F.tscn")
	if galleryGroup == "4F":
		get_tree().change_scene_to_file("res://NMFA/scenes/NMFA scenes/NMFA-4F.tscn")

func getDocument(document):
	var auth = Firebase.Auth.auth
	print("NEW_DATA: ", document)
	var fullData = newPath.get_data()
	for key in fullData.keys():
		if galleryLabel.text == key:
			%Visited.hide()
			%Unvisit.show()

func _on_visited_pressed():
	var auth = Firebase.Auth.auth
	newPath.update(galleryLabel.text, {0:0})
	%Visited.hide()
	%Unvisit.show()

func _on_unvisit_pressed():
	var auth = Firebase.Auth.auth
	newPath.delete("/" + galleryLabel.text)
	%Visited.show()
	%Unvisit.hide()
