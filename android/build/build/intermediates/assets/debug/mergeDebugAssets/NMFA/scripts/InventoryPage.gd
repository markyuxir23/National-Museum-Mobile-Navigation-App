extends Control

@onready var floorLabel = %FloorLabel
@onready var galleryLabel = %GalleryLabel
@onready var artsCardContainer = %ArtsCardContainer
@onready var _2fLocations = preload("res://NMFA/scenes/NMFA scenes/2f_locations_NMFA.tscn").instantiate().get_children()
@onready var _3fLocations = preload("res://NMFA/scenes/NMFA scenes/3f_locations_NMFA.tscn").instantiate().get_children()
@onready var _4fLocations = preload("res://NMFA/scenes/NMFA scenes/4f_locations.tscn").instantiate().get_children()
@onready var galleryData = StaticDatabase.gallery_data

@export var artCardScene: PackedScene

var F2galleries = []
var F3galleries = []
var F4galleries = []
var index = 0
var currentGallery

func _ready():
	initScene()

func initScene():
	for loc in _2fLocations:
		if loc.is_in_group("gallery"):
			F2galleries.append(loc.name)

	for loc in _3fLocations:
		if loc.is_in_group("gallery"):
			F3galleries.append(loc.name)
	
	for loc in _4fLocations:
		if loc.is_in_group("gallery"):
			F4galleries.append(loc.name)
			
	if Globals.floor_name == "2F":
		floorLabel.text = "NMFA Second Floor"
		currentGallery = F2galleries[0]
		Globals.currentGalleries = F2galleries
		galleryLabel.text = currentGallery
	elif Globals.floor_name == "3F":
		floorLabel.text = "NMFA Third Floor"
		currentGallery = F3galleries[0]
		Globals.currentGalleries = F3galleries
		galleryLabel.text = currentGallery
	elif Globals.floor_name == "4F":
		floorLabel.text = "NMFA Fourth Floor"
		currentGallery = F4galleries[0]
		Globals.currentGalleries = F4galleries
		galleryLabel.text = currentGallery
	initArtworks()

func initArtworks():
	Globals.currentArtworks.clear()
	var index = 0
	
	if artsCardContainer.get_children().size() != 0 or null:
		for i in artsCardContainer.get_children():
			artsCardContainer.remove_child(i)
		
	for gData in galleryData:
		if gData == currentGallery:
			Globals.currentArtworks.append(galleryData[gData])

	if Globals.currentArtworks[0].is_empty():
		%NoticeLabel.show()
	elif Globals.currentArtworks[0].is_empty() == false:
		%NoticeLabel.hide()
		for art in Globals.currentArtworks[0]:
			var artCard = artCardScene.instantiate()
			artsCardContainer.add_child(artCard)
			
			var infoButton = artCard.get_child(1).get_child(0)
			var label = artCard.get_child(1).get_child(1)
			infoButton.name = str(index)
			label.text = str(index + 1)
			index += 1

func _on_return_button_pressed():
	get_tree().change_scene_to_file(Globals.recent_scene)

func _on_right_pressed():
	if Globals.floor_name == "2F" && index != F2galleries.size() - 1:
		currentGallery = F2galleries[index + 1]
		galleryLabel.text = currentGallery
		initArtworks()
		index += 1
		
	if Globals.floor_name == "3F" && index != F3galleries.size() - 1:
		currentGallery = F3galleries[index + 1]
		galleryLabel.text = currentGallery
		initArtworks()
		index += 1

	if Globals.floor_name == "4F" && index != F4galleries.size() - 1:
		currentGallery = F4galleries[index + 1]
		galleryLabel.text = currentGallery
		initArtworks()
		index += 1

func _on_left_pressed():
	if Globals.floor_name == "2F" && index != 0:
		currentGallery = F2galleries[index - 1]
		galleryLabel.text = currentGallery
		initArtworks()
		index -= 1
		
	if Globals.floor_name == "3F" && index != 0:
		currentGallery = F3galleries[index - 1]
		galleryLabel.text = currentGallery
		initArtworks()
		index -= 1

	if Globals.floor_name == "4F" && index != 0:
		currentGallery = F4galleries[index - 1]
		galleryLabel.text = currentGallery
		initArtworks()
		index -= 1

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

func _on_left_floor_pressed():
	if Globals.floor_name == "2F":
		Globals.floor_name = "4F"
		print(Globals.floor_name)
		initScene()
		return
		
	if Globals.floor_name == "3F":
		Globals.floor_name = "2F"
		print(Globals.floor_name)
		initScene()
		return
		
	if Globals.floor_name == "4F":
		Globals.floor_name = "3F"
		print(Globals.floor_name)
		initScene()
		return
		
func _on_right_floor_pressed():
	if Globals.floor_name == "2F":
		Globals.floor_name = "3F"
		print(Globals.floor_name)
		initScene()
		return
		
	if Globals.floor_name == "3F":
		Globals.floor_name = "4F"
		print(Globals.floor_name)
		initScene()
		return
		
	if Globals.floor_name == "4F":
		Globals.floor_name = "2F"
		print(Globals.floor_name)
		initScene()
		return

func _on_search_pressed():
	pass # Replace with function body.
