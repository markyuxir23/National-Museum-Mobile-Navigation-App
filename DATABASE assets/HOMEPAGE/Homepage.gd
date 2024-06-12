extends Control
@onready var rawNMFA = {0:0}
@onready var rawNMA = {0:0}
@onready var visitData = {0:0}

@onready var NMFAGalleries = []
@onready var NMAGalleries = []
@onready var visitDataNMFA = []
@onready var visitDataNMA = []
@onready var matches = []

@export var galleryScene:PackedScene
@export var artworkScene:PackedScene

@onready var auth = Firebase.Auth.auth
@onready var userVisitDB = Firebase.Database.get_database_reference("userData/userVisited/" + auth.localid)
@onready var visitDB = Firebase.Database.get_database_reference("userData/userVisited")
@onready var dbNMFA = Firebase.Database.get_database_reference("museumData/FineArts/NMFA")
@onready var dbNMA = Firebase.Database.get_database_reference("museumData/NMA/-O-2WAeCWqHEaOYcf2Ro")

@onready var galleryChoice
@onready var currentGallery
@onready var onArtworks = false

signal editButtonPressed(galleryName)
signal saveArtwork(artworkName)
signal deleteArtwork(artworkName)

func _ready():
	dbNMFA.new_data_update.connect(updateData)
	dbNMFA.patch_data_update.connect(updateData)
	dbNMFA.delete_data_update.connect(updateData)
	
	dbNMA.new_data_update.connect(updateData)
	dbNMA.patch_data_update.connect(updateData)
	dbNMA.delete_data_update.connect(updateData)
	
	visitDB.new_data_update.connect(updateData)
	visitDB.patch_data_update.connect(updateData)
	visitDB.delete_data_update.connect(updateData)

	userVisitDB.new_data_update.connect(updateData)
	userVisitDB.patch_data_update.connect(updateData)
	userVisitDB.delete_data_update.connect(updateData)
	await get_tree().create_timer(3.00).timeout
	if auth.localid:
		var collection: FirestoreCollection = Firebase.Firestore.collection("user_data")
		var task: FirestoreTask = collection.get_doc(auth.localid)
		var finishedTask: FirestoreTask = await task.task_finished
		var document = finishedTask.document
		if document.doc_fields.username:
			%UserNameLabel.text = document.doc_fields.username
			userVisitDB.update("username", {document.doc_fields.username:0})
	
	rawNMFA = dbNMFA.get_data()
	rawNMA = dbNMA.get_data()
	visitData = visitDB.get_data()
	StaticDatabase.gallery_data = dbNMFA.get_data()
	StaticDatabaseNMA.gallery_data = dbNMA.get_data()
	
	getDocument()

	if DbGlobals.isAdmin == true:
		%ChangePasswordField.show()
		%ProgressBars.hide()
		%Explore.name = "Maintainance"
		%UserVisitations.show()
		%ExploreButtonsNMFA.hide()
		%ExploreButtonsNMA.hide()
		%EditNMA.show()
		%EditNMFA.show()
		adminUpdates()
	else:
		%ChangePasswordField.hide()
		%ProgressBars.show()
		%UserVisitations.hide()
		%ExploreButtonsNMFA.show()
		%ExploreButtonsNMA.show()
		%EditNMA.hide()
		%EditNMFA.hide()
		%Explore.name = "Explore"
	%LoadingScreen.hide()
	
func updateData(document):
	print("update")

func getDocument():
	var auth = Firebase.Auth.auth
	if visitData.keys().has(auth.localid):
		var fullData = userVisitDB.get_data()
		for visit in fullData.keys():
			if rawNMFA.keys().has(visit):
				visitDataNMFA.append(visit)
			elif rawNMFA.keys().has(visit):
				visitDataNMA.append(visit)
		
		var visitSizeNMFA: float
		visitSizeNMFA = visitDataNMFA.size()
		var rawSizeNMFA: float
		rawSizeNMFA = rawNMFA.keys().size()
		
		var visitSizeNMA: float
		visitSizeNMA = visitDataNMA.size()
		var rawSizeNMA: float
		rawSizeNMA = rawNMA.keys().size()
		
		%NMFAProgress.value = (visitSizeNMFA/rawSizeNMFA) * 10
		%NMAProgress.value = (visitSizeNMA/rawSizeNMA) * 10

func adminUpdates():
	var visitData = visitDB.get_data()
	for i in visitData:
		if str(i) != "dummy":
			%Users.text = %Users.text + "\n" + str(visitData[i]["username"].keys()) + ":    " + str(visitData[i].size()) + "/" + str(rawNMFA.size() + rawNMA.size())

func _on_log_out_pressed():
	Firebase.Auth.logout()
	get_tree().change_scene_to_file("res://DATABASE assets/LOGIN SYSTEM/Authentication.tscn")

func _on_nmfa_explore_pressed():
	get_tree().change_scene_to_file("res://NMFA/scenes/NMFA scenes/NMFA-2F.tscn")

func _on_nmfa_inventory_pressed():
	Globals.floor_name = "2F"
	Globals.recent_scene = "res://DATABASE assets/HOMEPAGE/Homepage.tscn"
	get_tree().change_scene_to_file("res://NMFA/scenes/InventoryPage.tscn")

func _on_nma_explore_pressed():
	get_tree().change_scene_to_file("res://NMA/scenes/NMA scenes/NMA-2F.tscn")

func _on_nma_inventory_pressed():
	GlobalsNMA.floor_name = "2F"
	GlobalsNMA.recent_scene = "res://DATABASE assets/HOMEPAGE/Homepage.tscn"
	get_tree().change_scene_to_file("res://NMA/scenes/InventoryPage.tscn")




#ADMIN FUNCS#########################
func _on_update_passcode_button_pressed():
	var auth = Firebase.Auth.auth
	var collection: FirestoreCollection = Firebase.Firestore.collection("admin_data")
	var adminDocID = "si7ZdcqqSnKMKYlkQ1P5"
	if auth.localid:
		var task: FirestoreTask = collection.update(adminDocID, {"passcode": %PasscodeLineEdit.text})
		%PasscodeLineEdit.text = ""
		%PasscodeLineEdit.placeholder_text = "New passcode submitted."

func _on_edit_nmfa_pressed():
	galleryChoice = true
	%GalleryInfoCard.hide()
	if %GalleryScroll.get_children().size() != 0 or null:
		for i in %GalleryScroll.get_children():
			if i != %GalleryInfoCard:
				%GalleryScroll.remove_child(i)
	var dataSource = dbNMFA.get_data()
	%SearchBG.show()
	%SearchScene.show()
	for gallery in dataSource.keys():
		var gall = galleryScene.instantiate()
		var galleryLabel = gall.get_child(0).get_child(0).get_child(0)
		galleryLabel.text = str(gallery)
		var editButton = gall.get_child(0).get_child(0).get_child(3)
		editButton.pressed.connect(self.emitGalleryName.bind(galleryLabel.text))
		%GalleryScroll.add_child(gall)

func _on_edit_nma_pressed():
	galleryChoice = false
	%GalleryInfoCard.hide()
	if %GalleryScroll.get_children().size() != 0 or null:
		for i in %GalleryScroll.get_children():
			if i != %GalleryInfoCard:
				%GalleryScroll.remove_child(i)
				
	var dataSource = dbNMA.get_data()
	%SearchBG.show()
	%SearchScene.show()
	for gallery in dataSource.keys():
		var gall = galleryScene.instantiate()
		var galleryLabel = gall.get_child(0).get_child(0).get_child(0)
		galleryLabel.text = str(gallery)
		var editButton = gall.get_child(0).get_child(0).get_child(3)
		editButton.pressed.connect(self.emitGalleryName.bind(galleryLabel.text))
		%GalleryScroll.add_child(gall)

func _on_close_pressed():
	%SearchBG.hide()
	%SearchScene.hide()

func _on_back_pressed():
	if galleryChoice:
		_on_edit_nmfa_pressed()
		%Back.hide()
	if not galleryChoice:
		_on_edit_nma_pressed()
		%Back.hide()
	
func _on_control_text_changed(new_text):
	new_text = new_text.to_lower()
	if new_text == "" or new_text == null or new_text == " ":
		for i in %GalleryScroll.get_children():
			i.show()
	else:
		matches.clear()
		for i in %GalleryScroll.get_children():
			if (i.get_child(0).get_child(0).get_child(0).text).to_lower().contains(new_text):
				matches.append(i)
		for i in %GalleryScroll.get_children():
			if i in matches:
				i.show() 
			else:
				i.hide()

#ARTWORK FUNCS#############
func _on_edit_button_pressed(galleryName):
	var dataSourceNMFA = dbNMFA.get_data()
	var dataSourceNMA = dbNMA.get_data()
	
	%Back.show()
	%AddGalleryContainer.hide()
	var artSource: Dictionary
	%GalleryInfoCard.show()
	currentGallery = galleryName

	if %GalleryScroll.get_children().size() != 0 or null:
		for i in %GalleryScroll.get_children():
			if i != %GalleryInfoCard:
				%GalleryScroll.remove_child(i)

	if dataSourceNMFA.keys().has(galleryName):
		artSource = dataSourceNMFA[galleryName]
		%GalleryName.text = galleryName
		var lead = dataSourceNMFA[galleryName].keys()[0]
		%HallName.text = dataSourceNMFA[galleryName][str(lead)]["gallery_hallname"]
		%GalleryInfo.text = dataSourceNMFA[galleryName][str(lead)]["gallery_info"]
	elif dataSourceNMA.keys().has(galleryName):
		%GalleryName.text = galleryName
		var lead = dataSourceNMA[galleryName].keys()[0]
		%HallName.text = dataSourceNMA[galleryName][str(lead)]["gallery_hallname"]
		%GalleryInfo.text = dataSourceNMA[galleryName][str(lead)]["gallery_info"]
		artSource = dataSourceNMA[galleryName]

	for artwork in artSource:
		var selected = artSource[artwork]
		var art = artworkScene.instantiate()
		%GalleryScroll.add_child(art)
		art.display(selected)
		var saveButton = art.get_node("VBoxContainer/SaveCancelButtons/Save")
		var deleteButton = art.get_node("VBoxContainer/HBoxContainer/WarningContainer/Yes")
		deleteButton.pressed.connect(self.emitToDelete.bind(artSource[artwork]["art_title"]))
		saveButton.pressed.connect(self.emitToSave.bind(artSource[artwork]["art_title"]))
		
func _on_delete_artwork(artworkName):
	print("DELETE: ", artworkName)
	
func _on_save_artwork(artworkName):
	print("SAVE: ", artworkName)

func emitGalleryName(galleryName):
	emit_signal("editButtonPressed", galleryName)

func emitToDelete(artworkName):
	emit_signal("deleteArtwork", artworkName)
	
func emitToSave(artworkName):
	emit_signal("saveArtwork", artworkName)



#GALLERY EDITS FUNCS ###############################3
func _on_delete_pressed():
	%Warning.text = "Are you sure you want to delete " + currentGallery + "?"
	%GalleryWarning.show()
	%GalleryEditDelete.hide()
	%GalleryLabels.hide()

func _on_no_pressed():
	%GalleryWarning.hide()
	%GalleryEditDelete.show()
	%GalleryLabels.show()

func _on_edit_pressed():
	onArtworks = true
	%GalleryLabels.hide()
	%GalleryEditDelete.hide()
	%GalleryDisplay.text = %GalleryName.text
	var labelsArray = %GalleryLabels.get_children()
	for property in labelsArray:
		if property == null:
			property = ""
		for lines in %GalleryLines.get_children():
			if str(lines.name).to_lower().contains(str(property.name).to_lower()):
				lines.text = property.text
	%GalleryLines.show()
	%GallerySaveCancel.show()

func _on_cancel_pressed():
	%GalleryLabels.show()
	%GalleryEditDelete.show()
	%GalleryLines.hide()
	%GallerySaveCancel.hide()

func _on_save_pressed():
	var lead
	var leadArtwork
	var dataNMFA = dbNMFA.get_data()
	var dataNMA = dbNMA.get_data()
	
	if galleryChoice:
		lead = dataNMFA[currentGallery].keys()[0]
		leadArtwork = dataNMFA[currentGallery][str(lead)]

	elif not galleryChoice:
		lead = dataNMA[currentGallery].keys()[0]
		leadArtwork = dataNMA[currentGallery][str(lead)]
	
	var updatedGallery = {
				"art_title": leadArtwork["art_title"],
				"art_artist": leadArtwork["art_artist"],
				"art_date": leadArtwork["art_date"],
				"art_place": leadArtwork["art_place"],
				"art_type": leadArtwork["art_type"],
				"gallery_hallname" : %HallNameLine.text,
				"gallery_info" : %GalleryInfoLine.text
		}
	
	if galleryChoice:
		dbNMFA.update(currentGallery + "/" + lead, updatedGallery)
	elif not galleryChoice:
		dbNMA.update(currentGallery + "/" + lead, updatedGallery)
	
	_on_cancel_pressed()

func _on_yes_pressed():
	if galleryChoice:
		dbNMFA.delete(currentGallery)
	elif not galleryChoice:
		dbNMA.delete(currentGallery)
	_on_back_pressed()

#ADD GALLERY FUNCS###################3
func _on_add_gallery_pressed():
	%AddGallery.hide()
	%NewGallerySaveCancel.show()
	%NewGalleryNameLine.text = "NEW GALLERY NAME"
	%NewHallNameLine.text = "NEW GALLERY HALLNAME"
	%NewGalleryInfoLine.text = "NEW GALLERY INFORMATION"
	%NewGalleryArtworkCode.text = "NEW GALLERY ARTWORK CODE"
	%NewGalleryLines.show()

func _on_new_gallery_cancel_pressed():
	%NewGallerySaveCancel.hide()
	%NewGalleryLines.hide()
	%AddGallery.show()

func _on_new_gallery_save_pressed():
	var partialGallery = { %NewGalleryArtworkCode.text + "_1": {
				"art_title": " ",
				"art_artist": " ",
				"art_date": " ",
				"art_place": " ",
				"art_type": " ",
				"gallery_hallname": %NewHallNameLine.text,
				"gallery_info": %NewGalleryInfoLine.text,
			}
		}
	
	if galleryChoice:
		dbNMFA.update(%NewGalleryNameLine.text, partialGallery)
	if not galleryChoice:
		dbNMA.update(%NewGalleryNameLine.text, partialGallery)
	_on_new_gallery_cancel_pressed()

func _on_refresh_pressed():
	if onArtworks:
		pass
	elif not onArtworks:
		_on_back_pressed()
