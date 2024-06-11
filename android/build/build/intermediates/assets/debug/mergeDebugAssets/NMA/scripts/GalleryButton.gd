extends Node

func _ready():
	var galleryName = self.name
	self.pressed.connect(self.emitName.bind(galleryName))

func emitName(name):
	emit_signal("galleryPressed", name)
