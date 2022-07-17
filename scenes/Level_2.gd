extends Node2D
signal level_finished

onready var upper_world = $UpperWorld
onready var lower_world = $LowerWorld


onready var tween = $Tween

var manifested_character = null

var down = true


func _ready() -> void:
	$LowerWorld/Character.vertical_level = true
	$UpperWorld/Character.vertical_level = true
	switch_world()


func _unhandled_input(event):
	if event.is_action("switch") and event.is_pressed():
		switch_world()


func switch_world() -> void:
	tween.stop_all()
	
	down = !down
	
	if down:
		MusicEngine.play_lower()
	else:
		MusicEngine.play_upper()
	
	$LowerWorld/Character.active = down
	$UpperWorld/Character.active = !down
