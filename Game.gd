extends Node2D

const TRANSITION_DURATION = 1.0

onready var levels := $Levels

onready var transition_camera := $TransitionCamera
onready var tween := $Tween

var current_level: Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	current_level = levels.get_child(0)
	var camera = current_level.find_node("Camera2D", true)
	camera.make_current()
	
	for level in levels.get_children():
		if level != current_level:
			set_freeze(level, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("next"):
		var next_level = $Levels.get_child(current_level.get_index() + 1)
		move_to(next_level)
	if Input.is_action_just_pressed("previous"):
		var next_level = $Levels.get_child(current_level.get_index() - 1)
		move_to(next_level)


func move_to(next_level: Node2D) -> void:
	var current_camera = current_level.find_node("Camera2D", true)
	var next_camera = next_level.find_node("Camera2D", true)
	
	set_freeze(current_level, true)
	
	transition_camera.make_current()
	
	tween.stop_all()
	tween.interpolate_property(
		transition_camera,
		"global_position",
		current_camera.global_position,
		next_camera.global_position,
		TRANSITION_DURATION,
		Tween.TRANS_QUAD,
		Tween.EASE_OUT
	)
	tween.interpolate_deferred_callback(
		self,
		TRANSITION_DURATION,
		"set_freeze",
		next_level,
		false
	)
	tween.interpolate_callback(
		next_camera,
		TRANSITION_DURATION,
		"make_current"
	)
	tween.start()
	current_level = next_level

func set_freeze(node: Node, freeze) -> void:
	node.propagate_call("set_process", [!freeze])
	#node.propagate_call("set_process_internal", [!freeze])
	
	node.propagate_call("set_physics_process", [!freeze])
	#node.propagate_call("set_physics_process_internal", [!freeze])
	
	node.propagate_call("set_process_input", [!freeze])
	node.propagate_call("set_process_unhandled_input", [!freeze])
	node.propagate_call("set_process_unhandled_key_input", [!freeze])





func _on_Test_level_finished():
	var next_level = $Levels.get_child(current_level.get_index() + 1)
	move_to(next_level)
