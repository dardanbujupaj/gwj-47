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
	if event.is_action("manifest") and event.is_pressed():
		var current_character = $LowerWorld/Character if down else $UpperWorld/Character
		if manifested_character == null or manifested_character == current_character:
			if current_character.active:
				current_character.active = false
				manifested_character = current_character
				manifestation.global_position = current_character.global_position * Vector2(1, -1)
				manifested_character.modulate = Color.gray
			else:
				manifested_character.modulate = Color.white
				current_character.active = true
				manifested_character = null
				manifestation.global_position = Vector2.LEFT * 10000


func switch_world() -> void:
	tween.stop_all()
	
	down = !down
	
	if $LowerWorld/Character != manifested_character:
		$LowerWorld/Character.active = down
	if $UpperWorld/Character != manifested_character:
		$UpperWorld/Character.active = !down
	
	
	var camera_pos = Vector2(640, 360) if down else Vector2(640, -360)
	tween.interpolate_property($Camera2D, "position", $Camera2D.position, camera_pos / 4, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	
	tween.start()
	

