extends Node2D
signal level_finished

onready var upper_world = $UpperWorld
onready var lower_world = $LowerWorld


onready var tween = $Tween


var down = true


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
	
	print("Move camera from %s to %s" % [$Camera2D.position, str(camera_pos)])
	tween.interpolate_property($Camera2D, "position", $Camera2D.position, camera_pos, 0.5, Tween.TRANS_QUAD, Tween.EASE_OUT)
	
	tween.start()

func _on_Exit_body_entered(body: Node2D):
	if body.name.begins_with("Character"):
		emit_signal("level_finished")
