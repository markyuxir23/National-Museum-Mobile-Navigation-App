extends Control
@onready var rawNMFA = StaticDatabase.gallery_data
@onready var rawNMA = StaticDatabaseNMA.gallery_data

@onready var NMFAGalleries = []
@onready var NMAGalleries = []
@onready var visitDataNMFA = []
@onready var visitDataNMA = []

var auth = Firebase.Auth.auth
var userVisitDB = Firebase.Database.get_database_reference("userData/userVisited/" + auth.localid)

func _ready():
	if DbGlobals.isAdmin == true:
		%ChangePasswordField.show()
	else:
		%ChangePasswordField.hide()

	userVisitDB.new_data_update.connect(getDocument)
	userVisitDB.patch_data_update.connect(getDocument)
	userVisitDB.delete_data_update.connect(getDocument)

	if auth.localid:
		var collection: FirestoreCollection = Firebase.Firestore.collection("user_data")
		var task: FirestoreTask = collection.get_doc(auth.localid)
		var finishedTask: FirestoreTask = await task.task_finished
		var document = finishedTask.document
		if document.doc_fields.username:
			%UserNameLabel.text = document.doc_fields.username

func getDocument(document):
	var auth = Firebase.Auth.auth
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

#func _on_update_pressed():
	#var auth = Firebase.Auth.auth
	#var fullData = userVisitDB.get_data()
	#for visit in fullData:
		#if NMFAGalleries.has(visit):
			#visitDataNMFA.append(visit)
		#elif NMAGalleries.has(visit):
			#visitDataNMA.append(visit)
	#%NMFAProgress.value = (visitDataNMFA.size()/NMFAGalleries.size()) * 100
	#%NMAProgress.value = (visitDataNMA.size()/NMAGalleries.size()) * 100
