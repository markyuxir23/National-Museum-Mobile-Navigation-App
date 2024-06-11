extends Node

@onready var isAdmin = false
@onready var visitData

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func saveData(collectionID, dataName, dataValue, taskType):
	var auth = Firebase.Auth.auth
	if auth.localid:
		var collection: FirestoreCollection = Firebase.Firestore.collection(collectionID)
		if taskType == "update":
			var data: Dictionary = {
				dataName: dataValue
			}
			var task: FirestoreTask = collection.update(auth.localid, data)
			await task.task_finished
