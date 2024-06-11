extends Control
@onready var rawNMFA
@onready var rawNMA

@onready var NMFAGalleries = []
@onready var NMAGalleries = []
@onready var visitDataNMFA = []
@onready var visitDataNMA = []

@export var galleryScene = preload("res://gallery_maintainance_card.tscn")

var auth = Firebase.Auth.auth
var userVisitDB = Firebase.Database.get_database_reference("userData/userVisited/" + auth.localid)
var visitDB = Firebase.Database.get_database_reference("userData/userVisited")
var dbNMFA = Firebase.Database.get_database_reference("museumData/FineArts/NMFA")
var dbNMA = Firebase.Database.get_database_reference("museumData/NMA/-O-2WAeCWqHEaOYcf2Ro")

func _ready():
	if auth.localid:
		var collection: FirestoreCollection = Firebase.Firestore.collection("user_data")
		var task: FirestoreTask = collection.get_doc(auth.localid)
		var finishedTask: FirestoreTask = await task.task_finished
		var document = finishedTask.document
		if document.doc_fields.username:
			%UserNameLabel.text = document.doc_fields.username

	dbNMFA.new_data_update.connect(updateData)
	dbNMFA.patch_data_update.connect(updateData)
	dbNMFA.delete_data_update.connect(updateData)
	
	rawNMFA = dbNMFA.get_data()
	rawNMA = dbNMA.get_data()
	
	StaticDatabase.gallery_data = dbNMFA.get_data()
	StaticDatabaseNMA.gallery_data = dbNMA.get_data()
	
	getDocument()
	
	visitDB.new_data_update.connect(getDocument)
	visitDB.patch_data_update.connect(getDocument)
	visitDB.delete_data_update.connect(getDocument)
	
	userVisitDB.new_data_update.connect(getDocument)
	userVisitDB.patch_data_update.connect(getDocument)
	userVisitDB.delete_data_update.connect(getDocument)

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
	await get_tree().create_timer(1.00).timeout
	%LoadingScreen.hide()
	
func updateData():
	print("done export")

func getDocument():
	var auth = Firebase.Auth.auth
	var visitData = visitDB.get_data()
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
	for i in visitData.keys():
		if str(i) != "dummy":
			%Users.text = %Users.text + "\n" + str(i) + ":    " + str(visitData[i].size()) + "/" + str(rawNMFA.size() + rawNMA.size())
	
	
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

func _on_update_passcode_button_pressed():
	var auth = Firebase.Auth.auth
	var collection: FirestoreCollection = Firebase.Firestore.collection("admin_data")
	var adminDocID = "si7ZdcqqSnKMKYlkQ1P5"
	if auth.localid:
		var task: FirestoreTask = collection.update(adminDocID, {"passcode": %PasscodeLineEdit.text})
		%PasscodeLineEdit.text = ""
		%PasscodeLineEdit.placeholder_text = "New passcode submitted."

func _on_edit_nmfa_pressed():
	if %GalleryScroll.get_children().size() != 0 or null:
		for i in %GalleryScroll.get_children():
			%GalleryScroll.remove_child(i)
	
	%SearchBG.show()
	%SearchScene.show()
	for gallery in StaticDatabase.gallery_data.keys():
		var gall = galleryScene.instantiate()
		gall.get_child(0).get_child(0).text = str(gallery)
		%GalleryScroll.add_child(gall)

func _on_edit_nma_pressed():
	if %GalleryScroll.get_children().size() != 0 or null:
		for i in %GalleryScroll.get_children():
			%GalleryScroll.remove_child(i)
	
	%SearchBG.show()
	%SearchScene.show()
	for gallery in StaticDatabaseNMA.gallery_data.keys():
		var gall = galleryScene.instantiate()
		gall.get_child(0).get_child(0).text = str(gallery)
		%GalleryScroll.add_child(gall)

func _on_close_pressed():
	%SearchBG.hide()
	%SearchScene.hide()
