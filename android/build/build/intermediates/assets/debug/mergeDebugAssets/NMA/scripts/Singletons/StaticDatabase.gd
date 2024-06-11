extends Node

@onready var current_galleries
var gallery_data

func _ready():
	gallery_data = importFromFile("res://NMA/database/NMA-JSONFILES/NMA.json")

func importFromFile(path: String):
	var data_file = FileAccess.open(path, FileAccess.READ)
	
	if not data_file:
		print("File not found!")
	var json_data = data_file.get_as_text()
	var data = JSON.parse_string(json_data)
	data_file.close()
	return(data)
	
	print(gallery_data)
