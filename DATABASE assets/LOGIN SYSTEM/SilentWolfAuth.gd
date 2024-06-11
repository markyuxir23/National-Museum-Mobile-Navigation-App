extends Control


func _ready():
	Firebase.Auth.login_succeeded.connect(onLoginSucceeded)
	Firebase.Auth.signup_succeeded.connect(onSignUpSucceeded)
	Firebase.Auth.login_failed.connect(onLoginFailed)
	Firebase.Auth.signup_failed.connect(onSignUpFailed)
	
	if Firebase.Auth.check_auth_file():
		%StateLabel.text = "Logged In Success!"
		get_tree().change_scene_to_file("res://NMFA/scenes/NMFA scenes/NMFA-2F.tscn")

func _on_log_in_pressed():
	var email = %EmailLineEdit.text
	var password = %PasswordLineEdit.text
	Firebase.Auth.login_with_email_and_password(email, password)
	%StateLabel.text = "Logging In"
	
func _on_sign_up_pressed():
	var email = %EmailLineEdit.text
	var password = %PasswordLineEdit.text
	Firebase.Auth.signup_with_email_and_password(email, password)
	%StateLabel.text = "Signing Up"

func onLoginSucceeded(auth):
	print(auth)
	%StateLabel.text = "Login success!"
	Firebase.Auth.save_auth(auth)
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
