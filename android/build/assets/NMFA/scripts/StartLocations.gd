extends VBoxContainer

@onready var origin = $"../../../../../.."
@onready var _2fLocations = %"2f-Locations".get_children()
@onready var _3fLocations = %"3F-Locations".get_children()
@onready var _4fLocations = %"4F-Locations".get_children()
signal buttonPressed(buttonName)

func _ready():
	if origin.is_in_group("2F"):
		locationInfo(_2fLocations)
	elif origin.is_in_group("3F"):
		locationInfo(_3fLocations)
	elif origin.is_in_group("4F"):
		locationInfo(_4fLocations)

func locationInfo(locations):
	for loc in locations:
		var button = get_child(0).duplicate()
		add_child(button)
		button.text = loc.name
		var itemName = loc.name
		button.pressed.connect(self.emitName.bind(itemName))
	remove_child(get_child(0))

func emitName(buttonName):
	emit_signal("buttonPressed", buttonName)
