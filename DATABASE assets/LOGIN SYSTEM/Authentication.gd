extends Control


func _ready():
	DbGlobals.isAdmin = false
	Firebase.Auth.login_succeeded.connect(onLoginSucceeded)
	Firebase.Auth.signup_succeeded.connect(onSignUpSucceeded)
	Firebase.Auth.login_failed.connect(onLoginFailed)
	Firebase.Auth.signup_failed.connect(onSignUpFailed)
	
	if Firebase.Auth.check_auth_file():
		if Firebase.Auth.auth["email"].contains("admin"):
			DbGlobals.isAdmin = true
			%StateLabel.text = "Admin Logged In Success!"
			get_tree().change_scene_to_file("res://DATABASE assets/HOMEPAGE/Homepage.tscn")
		else:
			%StateLabel.text = "Logged In Success!"
			get_tree().change_scene_to_file("res://DATABASE assets/HOMEPAGE/Homepage.tscn")

func _on_log_in_pressed():
	var email = %EmailLineEdit.text
	var password = %PasswordLineEdit.text
	Firebase.Auth.login_with_email_and_password(email, password)
	%StateLabel.text = "Logging In"

func _on_sign_up_pressed():
	var email = %EmailLineEdit.text
	var password = %PasswordLineEdit.text
	
	if email.contains("admin"):
		%StateLabel.text = "Invalid email, choose another email."
		return

	Firebase.Auth.signup_with_email_and_password(email, password)
	%StateLabel.text = "Signing Up"

func onLoginSucceeded(auth):
	print(auth)
	var email = %EmailLineEdit.text
	var password = %PasswordLineEdit.text
	Firebase.Auth.save_auth(auth)
	if email.contains("admin"):
		%AdminPassLineEdit.show()
		%StateLabel.text = "Enter the passcode to login as admin."
		auth = Firebase.Auth.auth
		var collection: FirestoreCollection = Firebase.Firestore.collection("admin_data")
		var adminDocID = "si7ZdcqqSnKMKYlkQ1P5"
		if auth.localid:
			var task: FirestoreTask = collection.get_doc(adminDocID)
			var finishedTask: FirestoreTask = await task.task_finished
			var document = finishedTask.document
			var passcode = document.doc_fields["passcode"]
			if %AdminPassLineEdit.text == passcode:
				%StateLabel.text = "Admin login success."
				DbGlobals.isAdmin = true
				get_tree().change_scene_to_file("res://DATABASE assets/HOMEPAGE/Homepage.tscn")
			else:
				%StateLabel.text = "Enter the correct passcode to login as admin."
				return
	else:
		%StateLabel.text = "Login success!"
		get_tree().change_scene_to_file("res://DATABASE assets/HOMEPAGE/Homepage.tscn")

func onSignUpSucceeded(auth):
	print(auth)
	%StateLabel.text = "Sign up success!"
	%UserNameLineEdit.show()
	%ConfirmButton.show()
	Firebase.Auth.save_auth(auth)
	
func onLoginFailed(error_code, message):
	print(error_code)
	print(message)
	%StateLabel.text = "Login failed. Error: %s" % message
	
func onSignUpFailed(error_code, message):
	print(error_code)
	print(message)
	%StateLabel.text = "Sign up failed. Error: %s" % message

func _on_confirm_button_pressed():
	DbGlobals.saveData("user_data", "username", %UserNameLineEdit.text, "update")
	get_tree().change_scene_to_file("res://DATABASE assets/HOMEPAGE/Homepage.tscn")

func _on_verify_button_pressed():
	pass # Replace with function body.
