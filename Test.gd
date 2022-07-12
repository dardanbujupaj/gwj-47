extends Node2D


onready var upper_world = $UpperWorld
onready var lower_world = $LowerWorld


onready var tween = $Tween

onready var manifestation = $Manifestation

var manifested_character = null

var down = false


func _ready() -> void:
	switch_world()


func _unhandled_input(event):
	if event.is_action("switch") and event.is_pressed():
		switch_world()
	


func switch_world() -> void:
	tween.stop_all()
	
	down = !down
	
	if $LowerWorld/Character != manifested_character:
		$LowerWorld/Character.active = down
	if $UpperWorld/Character != manifested_character:
		$UpperWorld/Character.active = !down
	
	var screen = Vector2(1920, 1080)
	
	var camera_pos = screen / 2 if down else screen / 2 * Vector2(1, -1)
	tween.interpolate_property($Camera2D, "position", $Camera2D.position, camera_pos, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	
	tween.start()
	

