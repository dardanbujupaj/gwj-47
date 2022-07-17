extends VBoxContainer



func _on_Button_pressed():
	get_tree().change_scene("res://scenes/Titlescreen.tscn")



func _on_button_mouse_entered():
	SoundEngine.play_sound("UIHover")


func _on_button_pressed():
	SoundEngine.play_sound("UIClick")
