extends Node

@onready var _2fLocations = preload("res://NMFA/scenes/NMFA scenes/2f_locations_NMFA.tscn").instantiate().get_children()
@onready var _3fLocations = preload("res://NMFA/scenes/NMFA scenes/3f_locations_NMFA.tscn").instantiate().get_children()
@onready var _4fLocations = preload("res://NMFA/scenes/NMFA scenes/4f_locations.tscn").instantiate().get_children()

#for floor switching
@onready var interfloor_origin
@onready var interfloor_destination
@onready var source_group

#for gallery info switching
@onready var recent_scene
@onready var gallery_sourcegroup
@onready var see_on_map_gallery

#for miscs panels
@onready var gallery_name
@onready var floor_name
@onready var currentArtworks: Array[Dictionary]
@onready var currentGalleries: Array

@onready var cannot_pan = false

func _ready():
	pass # Replace with function body.

func checkGroup(galleryName):
	for loc in _2fLocations:
		if galleryName == loc.name:
			see_on_map_gallery = loc
			return "2F"
	
	for loc in _3fLocations:
		if galleryName == loc.name:
			see_on_map_gallery = loc
			return "3F"
			
	for loc in _4fLocations:
		if galleryName == loc.name:
			see_on_map_gallery = loc
			return "4F"
