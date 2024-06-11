extends OptionButton

@onready var origin = $"../../../../../../.."

func _ready():
	if origin.is_in_group("2F"):
		selected = 0
	elif origin.is_in_group("3F"):
		selected = 1
	elif origin.is_in_group("4F"):
		selected = 2
