extends Node2D


func _ready():
	$Transitionscreen.connect("transitioned", self, ("transitioned"))
	$AnimationPlayer.play("1")


func _on_Start_pressed():
	$Transitionscreen.transition()
	$AnimationPlayer.play("2")

func transitioned():
	get_tree().change_scene("res://Introscene.tscn")
