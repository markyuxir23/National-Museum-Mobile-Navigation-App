extends Node2D

signal galleryPressed(name, pos)

@onready var _2F = %"2f-Locations".get_children()
@onready var _3F = %"3F-Locations".get_children()
@onready var _4F = %"4F-Locations".get_children()
@onready var originGroup = $"..".get_groups()[0]
@onready var originChildren = $"..".get_children()
@onready var galleryButton = preload("res://NMFA/scenes/GalleryButton.tscn")

@onready var galleryLocs = []
@onready var galleryNames = []

var hiPos = 110
var lowPos = 30
var hiSize = 438
var lowSize = 120

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in originChildren:
		if child.is_in_group(originGroup):
			var children = child.get_children()
			for i in children:
				if i.is_in_group("gallery"):
					galleryNames.append(i.name)
					galleryLocs.append(i)
	createButtons()

func createButtons():
	for i in galleryLocs:
		var gB = galleryButton.instantiate()
		if i.scale.x < i.scale.y:
			gB.size.x = lowSize
			gB.size.y = hiSize
			gB.position.y = i.global_position.y - hiPos
			gB.position.x = i.global_position.x - lowPos
		elif i.scale.x > i.scale.y:
			gB.position.y = i.global_position.y - lowPos
			gB.position.x = i.global_position.x - hiPos
		var galleryPos = gB.position
		var galleryName = i.name
		gB.pressed.connect(self.emitName.bind(galleryName, galleryPos))
		add_child(gB)

func emitName(name, pos):
	emit_signal("galleryPressed", name, pos)
