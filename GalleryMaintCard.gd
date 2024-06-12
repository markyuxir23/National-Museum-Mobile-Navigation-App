extends PanelContainer

var auth = Firebase.Auth.auth
var restrictDB = Firebase.Database.get_database_reference("restrictedData/Galleries/")
var restrictData: Dictionary

func _ready():
	restrictDB.new_data_update.connect(updateData)
	restrictDB.patch_data_update.connect(updateData)
	restrictDB.delete_data_update.connect(updateData)

func updateData(document):
	restrictData = restrictDB.get_data()
	if restrictData.keys().has(%GalleryNameLabel.text):
		%Restrict.hide()
		%Unrestrict.show()

func _on_restrict_pressed():
	%Restrict.hide()
	%Unrestrict.show()
	restrictDB.update(%GalleryNameLabel.text, {0:0})

func _on_unrestrict_pressed():
	restrictData = restrictDB.get_data()
	print(restrictData)
	for restrict in restrictData.keys():
		if restrict == %GalleryNameLabel.text:
			restrictDB.delete("/" +  %GalleryNameLabel.text)
	%Restrict.show()
	%Unrestrict.hide()
