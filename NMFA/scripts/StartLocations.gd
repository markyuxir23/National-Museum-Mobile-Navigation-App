extends VBoxContainer

@onready var origin = $"../../../../../.."
@onready var _2fLocations = preload("res://NMFA/scenes/NMFA scenes/2f_locations_NMFA.tscn").instantiate().get_children()
@onready var _3fLocations = preload("res://NMFA/scenes/NMFA scenes/3f_locations_NMFA.tscn").instantiate().get_children()
@onready var _4fLocations = preload("res://NMFA/scenes/NMFA scenes/4f_locations.tscn").instantiate().get_children()

var currentGalleries
var restrictDB = Firebase.Database.get_database_reference("restrictedData/Galleries/")
var restrictData: Dictionary

signal buttonPressed(buttonName)

func _ready():
	if origin.is_in_group("2F"):
		currentGalleries = _2fLocations
		locationInfo(_2fLocations)
	elif origin.is_in_group("3F"):
		currentGalleries = _3fLocations
		locationInfo(_3fLocations)
	elif origin.is_in_group("4F"):
		currentGalleries = _4fLocations
		locationInfo(_4fLocations)
	
	restrictDB.update("dummy", {0:0})
	
	restrictDB.new_data_update.connect(updateData)
	restrictDB.patch_data_update.connect(updateData)
	restrictDB.delete_data_update.connect(updateData)

func updateData(document):
	if get_children().size() != 0 or null:
		for i in get_children():
			if i.name != "OGButton":
				remove_child(i)

	restrictData = restrictDB.get_data()
	for loc in currentGalleries:
		if restrictData.keys().has(loc.name):
			loc.name = loc.name + "(RESTRICTED)"
	locationInfo(currentGalleries)

func locationInfo(locations):
	for loc in locations:
		var button = get_child(0).duplicate()
		add_child(button)
		button.text = loc.name
		var itemName = loc.name
		button.show()
		if loc.name.contains("(RESTRICTED)"):
			continue
		else:
			button.pressed.connect(self.emitName.bind(itemName))

func emitName(buttonName):
	emit_signal("buttonPressed", buttonName)
