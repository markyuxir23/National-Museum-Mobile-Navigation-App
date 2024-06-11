extends Control

@onready var _2F = $"../2f-Locations".get_children()
@onready var _3F = $"../3F-Locations".get_children()
@onready var _4F = $"../4F-Locations".get_children()
@onready var originGroup = $"..".get_groups()[0]
@onready var originChildren = $"..".get_children()
@onready var galleryButton = preload("res://NMA/scenes/GalleryButton.tscn")

@onready var galleryLocs = []


# Called when the node enters the scene tree for the first time.
func _ready():
	for child in originChildren:
		if child.is_in_group(originGroup):
			var children = child.get_children()
			for i in children:
				if i.is_in_group("gallery"):
					galleryLocs.append(i)
	createButtons()

func createButtons():
	for i in galleryLocs:
		var gB = galleryButton.instantiate()
		gB.position.y = i.global_position.y - 25
		gB.position.x = i.global_position.x - 60
		var galleryName = i.name
		add_child(gB)
