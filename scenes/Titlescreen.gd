extends Node2D


func _ready():
	$Transitionscreen.connect("transitioned", self, ("transitioned"))
	$AnimationPlayer.play("1")


func _on_Start_pressed():
	$Transitionscreen.transition()
	$AnimationPlayer.play("2")

func transitioned():
	get_tree().change_scene("res://scenes/Introscene.tscn")


func _on_Options_pressed():
	get_tree().change_scene("res://scenes/Settings.tscn")


func _on_button_mouse_entered():
	SoundEngine.play_sound("UIHover")


func _on_button_pressed():
	SoundEngine.play_sound("UIClick")
