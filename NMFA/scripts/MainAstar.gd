extends Node2D

@onready var tile_map = $TileMap
@onready var origin = $"."
@onready var startLine = $UI/Control/Start
@onready var destLine = $UI/Control/Destination
@onready var _4flocations = $"4F-Locations".get_children()
@onready var _3flocations = $"3F-Locations".get_children()
@onready var _2flocations = $"2f-Locations".get_children()
@onready var startScroll = $UI/Control/StartItems
@onready var destScroll = $UI/Control/DestItems
@onready var startItems = %MarginContainer.get_child(0).get_children()
@onready var destItems = %Destinations_NMFA.get_children()
@onready var destLocs = $DestLocations
@onready var pathLine = $Path
@onready var errorMessage = %Error
@onready var floorSelector = %OptionButton
@onready var galleryInfoPanel = %GalleryInfo
@onready var destIcon = preload("res://NMFA/scenes/landMark.tscn").instantiate()
@onready var startIcon = preload("res://NMA/scenes/landMark2.tscn").instantiate()
@onready var originGroup = origin.get_groups()[0]
@onready var galleries = get_tree().get_nodes_in_group("gallery")

var astar_grid: AStarGrid2D
var current_id_path: Array[Vector2i]
var current_point_path: PackedVector2Array
var to_draw_pointpath: PackedVector2Array
var isInOriginGroup = true
var isGallery = false
var selectedStart
var selectedDest
var selectedStartLabel
var selectedDestLabel
var interOrigin = Globals.interfloor_origin
var InterDest = Globals.interfloor_destination
var sourceGroup = Globals.source_group


func _ready():
	astar_grid = AStarGrid2D.new()
	astar_grid.region = tile_map.get_used_rect()
	astar_grid.cell_size = Vector2(16, 16)
	astar_grid.offset = astar_grid.cell_size / 2
	astar_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_MAX
	astar_grid.update()
	
	for x in tile_map.get_used_rect().size.x:
		for y in tile_map.get_used_rect().size.y:
			var tile_position = Vector2i(
				x + tile_map.get_used_rect().position.x,
				y + tile_map.get_used_rect().position.y
			)
			var tile_data = tile_map.get_cell_tile_data(0, tile_position)
			if tile_data == null or tile_data.get_custom_data("walkable") == false:
				astar_grid.set_point_solid(tile_position)
	
	Globals.recent_scene = get_tree().current_scene.scene_file_path
	Globals.gallery_sourcegroup = originGroup
	Globals.floor_name = originGroup
	StaticDatabase.current_galleries = galleries
	%Greetings.text = "National Museum of Fine Arts"
	galleryInfoPanel.hide()

	if destIcon.is_inside_tree():
		remove_child(destIcon)
	if startIcon.is_inside_tree():
		remove_child(startIcon)
	
	for i in _2flocations:
		var loc = i.duplicate()
		destLocs.add_child(loc)
	for j in _3flocations:
		var loc = j.duplicate()
		destLocs.add_child(loc)
	for k in _4flocations:
		var loc = k.duplicate()
		destLocs.add_child(loc)

	if interOrigin != null and InterDest != null:
		findOriginDest()
		pathFind(selectedStart, selectedDest)
		drawPath()
		camTween()
	
	if Globals.see_on_map_gallery != null:
		var gallerypanel = get_node("UI/GalleryInfo")
		var galleryPos = (Globals.see_on_map_gallery).global_position
		gallerypanel._on_gallery_manager_gallery_pressed(Globals.see_on_map_gallery.name, galleryPos)

func tweenOnPosition(tweenPos: Vector2):
	var tween = get_tree().create_tween()
	var zoom = Vector2(1.5, 1.5)
	var new_pos: Vector2
	new_pos.x = tweenPos.x + 25
	new_pos.y = tweenPos.y + 25
	
	tween.set_parallel(true)
	tween.tween_property(%MainCamera, "offset", new_pos, 0.5)
	tween.tween_property(%MainCamera, "zoom", zoom, 0.5)

func pathFind(from, to):
	var id_path = astar_grid.get_id_path(
		tile_map.local_to_map(from),
		tile_map.local_to_map(to)
	).slice(1)
	
	if id_path.is_empty() == false:
		current_id_path = id_path
		
		current_point_path = astar_grid.get_point_path(
			tile_map.local_to_map(from),
			tile_map.local_to_map(to)
		)

func minPath(nearestGroup):
	current_point_path = []
	var shortestPath = []
	var shortestDest = null
	var nearestArray = []
	
	for child in origin.get_children():
		if child.is_in_group(originGroup):
			for loc in child.get_children():
				if loc.is_in_group(nearestGroup):
					nearestArray.append(loc)
	var i = nearestArray.size()
	
	while i != 0 or null:
		for item in nearestArray:
			pathFind(selectedStart, item.global_position)
			if shortestPath.size() == 0:
				shortestDest = item
				shortestPath = current_point_path
			if current_point_path.size() < shortestPath.size():
				shortestDest = item
				shortestPath = current_point_path
			i -= 1

	Globals.interfloor_origin = shortestDest
	current_point_path = shortestPath

func drawPath():
	to_draw_pointpath = []
	if current_point_path.is_empty():
		return
	startIcon.global_position = selectedStart
	add_child(startIcon)
	for i in current_point_path:
		to_draw_pointpath.append(i)
		pathLine.set_default_color(Color.GREEN)
		pathLine.set_points(to_draw_pointpath)
		await get_tree().create_timer(0.01).timeout
	checkEstimates()
	if selectedDest != null:
		destIcon.global_position = selectedDest
		add_child(destIcon)

func findOriginDest():
	var newOrigin: String = interOrigin.replace(sourceGroup, originGroup)
	for child in origin.get_children():
		if child.is_in_group(originGroup):
			for loc in child.get_children():
				if loc.name == newOrigin:
					selectedStart = loc.global_position
				if loc.name == InterDest:
					selectedDest = loc.global_position

func camTween():
	var distancesTween = []
	var tween = get_tree().create_tween()
	var tweenPos = current_point_path[round((current_point_path.size() - 1)/2)]
	var tweenZoom = Vector2(1.5, 1.5)
	
	for child in origin.get_children():
		if child.is_in_group(originGroup):
			for loc in child.get_children():
				var distance = selectedStart.distance_to(loc.global_position)
				distancesTween.append(distance)
	
	var sum = 0
	for distance in distancesTween:
		sum += distance
	var average = round(sum/distancesTween.size())
	
	if selectedStart.distance_to(current_point_path[current_point_path.size() - 1]) > average:
		tweenZoom = Vector2(0.8, 0.8)
	else:
		tweenZoom = Vector2(1.2, 1.2)
	
	var newTweenPos: Vector2
	newTweenPos.x = tweenPos.x + 25
	newTweenPos.y = tweenPos.y + 25
	
	tween.set_parallel(true)
	tween.tween_property(%MainCamera, "offset", newTweenPos, 1)
	tween.tween_property(%MainCamera, "zoom", tweenZoom, 1)

func checkEstimates():
	var estDistance = to_draw_pointpath.size() * 30
	var ETA = to_draw_pointpath.size() * 1
	
	var estDistanceinM = estDistance / 100
	var ETAinMinutes = ETA / 60
	
	
	if snapped(estDistanceinM, 0.0000001) != 0 and snapped(ETAinMinutes, 0.0000001) != 0:
		%ETA.get_child(0).text = "Distance: " + str(estDistanceinM) + " m" + "\n" + "ETA: " + str(ETAinMinutes) + " min/s"
		return
	if snapped(estDistanceinM, 0.0000001) != 0 and snapped(ETAinMinutes, 0.0000001) == 0:
		%ETA.get_child(0).text = "Distance: " + str(estDistanceinM) + " m" + "\n" + "ETA: " + str(ETA) + " secs"
		return
	if snapped(estDistanceinM, 0.0000001) == 0 and snapped(ETAinMinutes, 0.0000001) != 0:
		%ETA.get_child(0).text = "Distance: " + str(estDistance) + " cm" + "\n" + "ETA: " + str(ETAinMinutes) + " min/s"
		return
	if snapped(estDistanceinM, 0.0000001) == 0 and snapped(ETAinMinutes, 0.0000001) == 0:
		%ETA.get_child(0).text = "Distance: " + str(estDistance) + " cm" + "\n" + "ETA: " + str(ETA) + " secs"
		return

func _on_start_buttons_nmfa_2f_button_pressed(buttonName):
	startScroll.visible = false
	startLine.text = buttonName
	for i in _2flocations:
		if i.name == buttonName:
			selectedStart = i.global_position
			selectedStartLabel = i.name

func _on_start_buttons_nmfa_3f_button_pressed(buttonName):
	startScroll.visible = false
	startLine.text = buttonName
	for i in _3flocations:
		if i.name == buttonName:
			selectedStart = i.global_position
			selectedStartLabel = i.name

func _on_start_buttons_nmfa_4f_button_pressed(buttonName):
	startScroll.visible = false
	startLine.text = buttonName
	for i in _4flocations:
		if i.name == buttonName:
			selectedStart = i.global_position
			selectedStartLabel = i.name

func _on_destinations_nmfa_button_pressed(buttonName):
	destScroll.visible = false
	destLine.text = buttonName
	# No destlabel if not on the same floor, label on the next scenefloor
	for loc in destLocs.get_children():
		if loc.name == buttonName:
			if loc.is_in_group(originGroup) == false:
				if loc.is_in_group("gallery"):
					isGallery = true
				else:
					isGallery = false
				isInOriginGroup = false
				Globals.interfloor_destination = loc
				
			elif loc.is_in_group(originGroup) == true:
				if loc.is_in_group("gallery"):
					isGallery = true
				else:
					isGallery = false
				isInOriginGroup = true
				selectedDest = loc.global_position
				selectedDestLabel = loc.name

func _on_directions_pressed():
	if destIcon.is_inside_tree():
		remove_child(destIcon)
	if startIcon.is_inside_tree():
		remove_child(startIcon)

	%ETA.show()
	
	var interDest = Globals.interfloor_destination
	if isInOriginGroup == false:
		minPath("stairs")
		drawPath()
		camTween()
		Globals.interfloor_destination = Globals.interfloor_destination.name
		Globals.interfloor_origin = Globals.interfloor_origin.name
		Globals.source_group = originGroup
		if interDest.is_in_group("2F"):
			await get_tree().create_timer(2.00).timeout
			get_tree().change_scene_to_file("res://NMFA/scenes/NMFA scenes/NMFA-2F.tscn")
		elif interDest.is_in_group("3F"):
			await get_tree().create_timer(2.00).timeout
			get_tree().change_scene_to_file("res://NMFA/scenes/NMFA scenes/NMFA-3F.tscn")
		elif interDest.is_in_group("4F"):
			await get_tree().create_timer(2.00).timeout
			get_tree().change_scene_to_file("res://NMFA/scenes/NMFA scenes/NMFA-4F.tscn")
			
	elif isInOriginGroup:
		pathFind(selectedStart, selectedDest)
		drawPath()
		camTween()


func _on_option_button_item_selected(index):
	Globals.interfloor_destination = null
	Globals.interfloor_origin = null
	galleryInfoPanel.hide()
	if get_tree().current_scene.is_in_group(floorSelector.get_item_text(index)):
		return
	elif get_tree().current_scene.is_in_group(floorSelector.get_item_text(index)) == false:
		if index == 0:
			get_tree().change_scene_to_file("res://NMFA/scenes/NMFA scenes/NMFA-2F.tscn")
		elif index == 1:
			get_tree().change_scene_to_file("res://NMFA/scenes/NMFA scenes/NMFA-3F.tscn")			
		elif index == 2:
			get_tree().change_scene_to_file("res://NMFA/scenes/NMFA scenes/NMFA-4F.tscn")


func _on_home_button_pressed():
	get_tree().change_scene_to_file("res://DATABASE assets/HOMEPAGE/Homepage.tscn")
