extends Control
@onready var menu = %Menu


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_close_button_toggled(toggled_on):
	if toggled_on == true:
		menu.show()
		size.y = 344
	elif toggled_on == false:
		menu.hide()
		size.y = 183.2


func _on_inventory_pressed():
	get_tree().change_scene_to_file("res://NMA/scenes/InventoryPage.tscn")
