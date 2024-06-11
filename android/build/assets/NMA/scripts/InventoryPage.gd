extends Control

@onready var floorLabel = %FloorLabel
@onready var galleryLabel = %GalleryLabel
@onready var artsCardContainer = %ArtsCardContainer
@onready var _2fLocations = preload("res://NMA/scenes/NMA scenes/2f_locations_NMA.tscn").instantiate().get_children()
@onready var _3fLocations = preload("res://NMA/scenes/NMA scenes/3f_locations_NMA.tscn").instantiate().get_children()
@onready var _4fLocations = preload("res://NMA/scenes/NMA scenes/4f_locations.tscn").instantiate().get_children()
@onready var galleryData = StaticDatabaseNMA.gallery_data

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
			
	if GlobalsNMA.floor_name == "2F":
		floorLabel.text = "NMA Second Floor"
		currentGallery = F2galleries[0]
		galleryLabel.text = currentGallery
	elif GlobalsNMA.floor_name == "3F":
		floorLabel.text = "NMA Third Floor"
		currentGallery = F3galleries[0]
		galleryLabel.text = currentGallery
	elif GlobalsNMA.floor_name == "4F":
		floorLabel.text = "NMA Fourth Floor"
		currentGallery = F4galleries[0]
		galleryLabel.text = currentGallery
	initArtworks()

func initArtworks():
	GlobalsNMA.currentArtworks.clear()
	var index = 0
	
	if artsCardContainer.get_children().size() != 0 or null:
		for i in artsCardContainer.get_children():
			artsCardContainer.remove_child(i)
		
	for gData in galleryData:
		if gData == currentGallery:
			GlobalsNMA.currentArtworks.append(galleryData[gData])

	if GlobalsNMA.currentArtworks[0].is_empty():
		%NoticeLabel.show()
	elif GlobalsNMA.currentArtworks[0].is_empty() == false:
		%NoticeLabel.hide()
		for art in GlobalsNMA.currentArtworks[0]:
			var artCard = artCardScene.instantiate()
			artsCardContainer.add_child(artCard)
			
			var infoButton = artCard.get_child(1).get_child(0)
			var label = artCard.get_child(1).get_child(1)
			infoButton.name = str(index)
			label.text = str(index + 1)
			index += 1

func _on_return_button_pressed():
	get_tree().change_scene_to_file(GlobalsNMA.recent_scene)

func _on_right_pressed():
	if GlobalsNMA.floor_name == "2F" && index != F2galleries.size() - 1:
		currentGallery = F2galleries[index + 1]
		galleryLabel.text = currentGallery
		initArtworks()
		index += 1
		
	if GlobalsNMA.floor_name == "3F" && index != F3galleries.size() - 1:
		currentGallery = F3galleries[index + 1]
		galleryLabel.text = currentGallery
		initArtworks()
		index += 1

	if GlobalsNMA.floor_name == "4F" && index != F4galleries.size() - 1:
		currentGallery = F4galleries[index + 1]
		galleryLabel.text = currentGallery
		initArtworks()
		index += 1

func _on_left_pressed():
	if GlobalsNMA.floor_name == "2F" && index != 0:
		currentGallery = F2galleries[index - 1]
		galleryLabel.text = currentGallery
		initArtworks()
		index -= 1
		
	if GlobalsNMA.floor_name == "3F" && index != 0:
		currentGallery = F3galleries[index - 1]
		galleryLabel.text = currentGallery
		initArtworks()
		index -= 1

	if GlobalsNMA.floor_name == "4F" && index != 0:
		currentGallery = F4galleries[index - 1]
		galleryLabel.text = currentGallery
		initArtworks()
		index -= 1

func _on_see_on_map_pressed():
	GlobalsNMA.interfloor_destination = null
	GlobalsNMA.interfloor_origin = null
	GlobalsNMA.see_on_map_gallery = null
	var galleryGroup = GlobalsNMA.checkGroup(galleryLabel.text)
	if galleryGroup == "2F":
		get_tree().change_scene_to_file("res://NMA/scenes/NMA scenes/NMA-2F.tscn")
	if galleryGroup == "3F":
		get_tree().change_scene_to_file("res://NMA/scenes/NMA scenes/NMA-3F.tscn")
	if galleryGroup == "4F":
		get_tree().change_scene_to_file("res://NMA/scenes/NMA scenes/NMA-4F.tscn")


func _on_left_floor_pressed():
	if GlobalsNMA.floor_name == "2F":
		GlobalsNMA.floor_name = "4F"
		print(GlobalsNMA.floor_name)
		initScene()
		return
		
	if GlobalsNMA.floor_name == "3F":
		GlobalsNMA.floor_name = "2F"
		print(GlobalsNMA.floor_name)
		initScene()
		return
		
	if GlobalsNMA.floor_name == "4F":
		GlobalsNMA.floor_name = "3F"
		print(GlobalsNMA.floor_name)
		initScene()
		return
		
func _on_right_floor_pressed():
	if GlobalsNMA.floor_name == "2F":
		GlobalsNMA.floor_name = "3F"
		print(GlobalsNMA.floor_name)
		initScene()
		return
		
	if GlobalsNMA.floor_name == "3F":
		GlobalsNMA.floor_name = "4F"
		print(GlobalsNMA.floor_name)
		initScene()
		return
		
	if GlobalsNMA.floor_name == "4F":
		GlobalsNMA.floor_name = "2F"
		print(GlobalsNMA.floor_name)
		initScene()
		return
