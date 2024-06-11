extends Camera2D

@export var zoom_speed: float = 0.1
@export var pan_speed: float = 1.0
@export var rotation_speed: float = 1.0

@export var can_pan: bool
@export var can_zoom: bool
@export var can_rotate: bool

@onready var control 

var touch_points: Dictionary = {}
var start_distance
var start_zoom
var start_angle
var current_angle

func _process(delta):
	if Globals.cannot_pan == false:
		can_pan = true
		can_rotate = true
		can_zoom = true
	elif Globals.cannot_pan == true:
		can_pan = false
		can_rotate = false
		can_zoom = false

func _input(event):
	if event is InputEventScreenTouch:
		handle_touch(event)
	elif event is InputEventScreenDrag:
		handle_drag(event)
		
func handle_touch(event: InputEventScreenTouch):
	if event.pressed:
		touch_points[event.index] = event.position
	else:
		touch_points.erase(event.index)
	
	if touch_points.size() == 2:
		var touch_point_positions = touch_points.values()
		start_distance = touch_point_positions[0].distance_to(touch_point_positions[1])
		start_angle = get_angle(touch_point_positions[0], touch_point_positions[1])
		start_zoom = zoom
	elif touch_points.size() < 2:
		start_distance = 0
		
func handle_drag(event: InputEventScreenDrag):
	touch_points[event.index] = event.position
	
	if touch_points.size() == 1:
		if can_pan:
			offset -= event.relative.rotated(rotation) * pan_speed/zoom.x
			limit_pan(offset)
			
	elif touch_points.size() == 2:
		var touch_point_positions = touch_points.values()
		var current_dist = touch_point_positions[0].distance_to(touch_point_positions[1])
		var current_angle = get_angle(touch_point_positions[0], touch_point_positions[1])
		var zoom_factor = start_distance / current_dist
		
		if can_zoom:
			zoom = start_zoom / zoom_factor
		if can_rotate:
			rotation -= (current_angle - start_angle) * rotation_speed
			start_angle = current_angle
		limit_zoom(zoom)

func limit_pan(new_offset):
	var max_pan = 1300
	var min_pan = -1300
	
	if new_offset.x < min_pan:
		offset.x = min_pan
	if new_offset.y < min_pan:
		offset.y = min_pan + 200
	if new_offset.x > max_pan:
		offset.x = max_pan
	if new_offset.y > max_pan:
		offset.y = max_pan - 200

func limit_zoom(new_zoom):
	var max_zoom = 10
	var min_zoom = 0.35
	
	if new_zoom.x < min_zoom:
		zoom.x = min_zoom
	if new_zoom.y < min_zoom:
		zoom.y = min_zoom
	if new_zoom.x > max_zoom:
		zoom.x = max_zoom
	if new_zoom.y > max_zoom:
		zoom.y = max_zoom
	

func get_angle(p1, p2):
	var delta = p2 - p1
	return fmod((atan2(delta.y, delta.x) + PI), (2 * PI))
