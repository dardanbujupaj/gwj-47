extends Node2D




func _ready():
	$Transitionscreen.connect("transitioned", self, ("transitioned"))
	$AnimationPlayer.play("movement_1")
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Dialog_dialogic_signal(value):
	if (value) == "move":
		$AnimationPlayer.play("movement_2")
	if (value) == "crash":
		$Camera2D.add_trauma(1)
	if (value) == "transition":
		$Transitionscreen.transition()

func transitioned():
	get_tree().change_scene("res://Game.tscn")
