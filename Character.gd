extends KinematicBody2D


const ACCELERATION = 2400
const DECCELERATION = 4800

const MAX_SPEED = 1000

const JUMP_STRENGTH = 700

const JUMP_GRAVITY = 1500
const RAISE_GRAVITY = 3000
const FALL_GRAVITY = 4500


var start_position: Vector2

var velocity: Vector2


var active: bool = false

#onready var animation_tree := $AnimationTree
#onready var state_machine := $AnimationTree["parameters/playback"] as AnimationNodeStateMachinePlayback

#onready var hit_area = $HitArea


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_position = position


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	
	if not active:
		return
	
	if can_jump():
		if Input.is_action_just_pressed("up"):
			velocity.y -= JUMP_STRENGTH
	
	if velocity.y < 0:
		if Input.is_action_pressed("up"):
			velocity.y += JUMP_GRAVITY * delta
		else:
			velocity.y += RAISE_GRAVITY * delta
	else:
		velocity.y += FALL_GRAVITY * delta
	
	
	var horizontal_input := Input.get_action_strength("right") - Input.get_action_strength("left")
	
	
	if abs(horizontal_input) > 0:
		# $Sprites.scale.x = horizontal_input
		
		if abs(velocity.x) != abs(horizontal_input):
			velocity.x += horizontal_input * delta * DECCELERATION
		velocity.x += horizontal_input * delta * ACCELERATION
	else:
		var decceleration = sign(velocity.x) * delta * DECCELERATION
		if abs(velocity.x) < abs(decceleration):
			velocity.x = 0
		else:
			velocity.x -= decceleration
	
	
	velocity.x = clamp(velocity.x, -MAX_SPEED, MAX_SPEED)
	
	#if abs(velocity.x) > 1 and $SoundTimer.is_stopped():
	#	$SoundTimer.start()
	#elif abs(velocity.x) <= 1 and not $SoundTimer.is_stopped():
	#	$SoundTimer.stop()
	
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	#animation_tree["parameters/conditions/moving"] = abs(horizontal_input) != 0.0
	#animation_tree["parameters/conditions/not_moving"] = abs(horizontal_input) == 0.0


func can_jump():
	return is_on_floor()


func _on_SoundTimer_timeout() -> void:
	$SoundTimer.wait_time = rand_range(0.1, 0.2)
	$AudioStreamPlayer2D.pitch_scale = 1.0 + rand_range(-0.2, 0.2)
	$AudioStreamPlayer2D.play()
