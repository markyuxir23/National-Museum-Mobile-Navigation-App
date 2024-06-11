extends VBoxContainer

@onready var origin = $"../../../../../../.."
@onready var _2fLocations = preload("res://NMA/scenes/NMA scenes/2f_locations_NMA.tscn").instantiate().get_children()
@onready var _3fLocations = preload("res://NMA/scenes/NMA scenes/3f_locations_NMA.tscn").instantiate().get_children()
@onready var _4fLocations = preload("res://NMA/scenes/NMA scenes/4f_locations.tscn").instantiate().get_children()
signal buttonPressed(buttonName)

var include2F = true
var include3F = true
var include4F = true

@export var _2F_Tag: Texture
@export var _3F_Tag: Texture
@export var _4F_Tag: Texture

func _ready():
	if origin.is_in_group("2F"):
		_on_option_button_item_selected(0)
	if origin.is_in_group("3F"):
		_on_option_button_item_selected(1)
	if origin.is_in_group("4F"):
		_on_option_button_item_selected(2)

func constructButtons(locations, tag):
	for loc in locations:
		var button = %Button.duplicate()
		add_child(button)
		button.show()
		button.text = loc.name
		var itemName = loc.name
		button.icon = tag
		button.pressed.connect(self.emitName.bind(itemName))
		
func emitName(buttonName):
	emit_signal("buttonPressed", buttonName)

func _on_option_button_item_selected(index):
	if index == 0:
		for child in get_children():
			if child == %Button:
				continue
			else:
				child.queue_free()
		constructButtons(_2fLocations, _2F_Tag)
	if index == 1:
		for child in get_children():
			if child == %Button:
				continue
			else:
				child.queue_free()
		constructButtons(_3fLocations, _3F_Tag)
	if index == 2:
		for child in get_children():
			if child == %Button:
				continue
			else:
				child.queue_free()
		constructButtons(_4fLocations, _4F_Tag)

