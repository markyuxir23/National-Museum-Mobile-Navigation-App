extends VBoxContainer

@onready var origin = $"../../../../../../.."
@onready var _2fLocations = preload("res://NMFA/scenes/NMFA scenes/2f_locations_NMFA.tscn").instantiate().get_children()
@onready var _3fLocations = preload("res://NMFA/scenes/NMFA scenes/3f_locations_NMFA.tscn").instantiate().get_children()
@onready var _4fLocations = preload("res://NMFA/scenes/NMFA scenes/4f_locations.tscn").instantiate().get_children()
signal buttonPressed(buttonName)


var restrictDB = Firebase.Database.get_database_reference("restrictedData/Galleries/")
var restrictData: Dictionary

var include2F = true
var include3F = true
var include4F = true

var currentGalleries
var currentTag

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
		
	restrictDB.update("dummy", {0:0})
	
	restrictDB.new_data_update.connect(updateData)
	restrictDB.patch_data_update.connect(updateData)
	restrictDB.delete_data_update.connect(updateData)

func updateData(document):
	if get_children().size() != 0 or null:
		for i in get_children():
			if i.name != "Button":
				remove_child(i)

	restrictData = restrictDB.get_data()
	for loc in currentGalleries:
		if restrictData.keys().has(loc.name):
			loc.name = loc.name + "(RESTRICTED)"
	constructButtons(currentGalleries, currentTag)

func constructButtons(locations, tag):
	for loc in locations:
		var button = get_child(0).duplicate()
		add_child(button)
		button.show()
		button.text = loc.name
		var itemName = loc.name
		button.icon = tag
		if loc.name.contains("(RESTRICTED)"):
			continue
		else:
			button.pressed.connect(self.emitName.bind(itemName))
		
func emitName(buttonName):
	emit_signal("buttonPressed", buttonName)

func _on_option_button_item_selected(index):
	if index == 0:
		currentGalleries = _2fLocations
		currentTag = _2F_Tag
		for child in get_children():
			if child == %Button:
				continue
			else:
				child.queue_free()
		constructButtons(_2fLocations, _2F_Tag)
	if index == 1:
		currentGalleries = _3fLocations
		currentTag = _3F_Tag
		for child in get_children():
			if child == %Button:
				continue
			else:
				child.queue_free()
		constructButtons(_3fLocations, _3F_Tag)
	if index == 2:
		currentGalleries = _4fLocations
		currentTag = _4F_Tag
		for child in get_children():
			if child == %Button:
				continue
			else:
				child.queue_free()
		constructButtons(_4fLocations, _4F_Tag)
