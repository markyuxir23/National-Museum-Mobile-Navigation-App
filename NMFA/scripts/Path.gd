extends Node2D

@onready var origin = $".."

#func _process(delta):
#	await get_tree().create_timer(1.0).timeout
#	queue_redraw()
#
#func _draw():
#	var to_draw_pointpath = []
#	var i = 0
#	if origin.current_point_path.is_empty():
#		return
#	while to_draw_pointpath.size() != origin.current_point_path.size():
#		var origin_path = origin.current_point_path
#		to_draw_pointpath.append(origin_path[i])
#		draw_polyline(to_draw_pointpath, Color.BLACK, 4)
#		i += 1
