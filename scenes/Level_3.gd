extends Node2D
signal level_finished

onready var upper_world = $UpperWorld
onready var lower_world = $LowerWorld


onready var tween = $Tween

var manifested_character = null
var box = 0
var down = true


func _ready() -> void:
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
	
	
	var screen = Vector2(1920, 1080)
	
	var camera_pos = screen / 2 if down else screen / 2 * Vector2(1, -1)
	
	tween.interpolate_property($Camera2D, "position", $Camera2D.position, camera_pos, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	
	tween.start()



func _on_MovableTile_box_in():
	box += 1
	check_boxes()



func _on_MovableTile_box_out():
	box -= 1
	check_boxes()

func _on_MovableTile2_box_in():
	box += 1
	check_boxes()



func _on_MovableTile2_box_out():
	box -= 1
	check_boxes()



func check_boxes():
	if box == 4:
		print("finished")
		emit_signal("level_finished")






