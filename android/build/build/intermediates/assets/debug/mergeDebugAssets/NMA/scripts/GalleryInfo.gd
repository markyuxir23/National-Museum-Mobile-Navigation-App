extends Control

@onready var camera = %MainCamera
@onready var label = $Container/MainPanel/PanelContainer/MarginContainer/VBoxContainer/HBoxContainer/Label
@export var menuSize = 0.3
@export var lerpSpeed = 0.2

var upAnchor = Vector2(1 - menuSize, 1)
var downAnchor = Vector2(1, 1 + menuSize)
var targetAnchor = downAnchor

func _ready():
	self.visible = false
	
func _gui_input(event):
	var touch_pos = get_local_mouse_position()
	if Rect2(0, 0, 1080, 745.008).has_point(touch_pos) == true:
		GlobalsNMA.cannot_pan = true
	elif Rect2(0, 0, 1080, 745.008).has_point(touch_pos) == false:
		GlobalsNMA.cannot_pan = false

func _process(delta):
	anchor_top = lerp(anchor_top, targetAnchor.x, lerpSpeed)
	anchor_bottom = lerp(anchor_bottom, targetAnchor.y, lerpSpeed)
	
func _on_gallery_manager_gallery_pressed(name, pos):
	var tween = get_tree().create_tween()
	var zoom = Vector2(1.5, 1.5)
	var new_pos: Vector2
	new_pos.x = pos.x + 25
	new_pos.y = pos.y + 25
	
	tween.set_parallel(true)
	tween.tween_property(%MainCamera, "offset", new_pos, 0.5)
	tween.tween_property(%MainCamera, "zoom", zoom, 0.5)
	
	self.visible = true
	targetAnchor = upAnchor
	label.text = name
	GlobalsNMA.gallery_name = name

func _on_menu_pressed():
	targetAnchor = downAnchor

func _on_gallery_info_button_pressed():
	get_tree().change_scene_to_file("res://NMA/scenes/GalleryInfoPanel.tscn")
