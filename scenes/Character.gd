extends KinematicBody2D


export(Texture) var texture = preload("res://Assets/Character/Character.png") setget _set_texture


const ACCELERATION = 1600
const DECCELERATION = 2400

const MAX_SPEED = 700

const JUMP_STRENGTH = 800

const JUMP_GRAVITY = 1400
const RAISE_GRAVITY = 1600
const FALL_GRAVITY = 2400

export var vertical_level = false 

var start_position: Vector2

var velocity: Vector2


export var active: bool = false setget _set_active

var transformed = false
var manifestation: Node2D

onready var animation_tree := $AnimationTree
onready var state_machine := $AnimationTree["parameters/playback"] as AnimationNodeStateMachinePlayback

#onready var hit_area = $HitArea




var sounds = {
	"jump": preload("res://Assets/Soundeffects/jump.wav"),
	"land": preload("res://Assets/Soundeffects/land.wav"),
	"run": preload("res://Assets/Soundeffects/run.wav"),
	"transform": preload("res://Assets/Soundeffects/transform.wav"),
}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_position = position



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if active and Input.is_action_just_pressed("transform"):
		transform()
	
	if transformed:
		return
	
	if active and can_jump():
		if Input.is_action_just_pressed("up"):
			velocity.y -= JUMP_STRENGTH
	
	if velocity.y < 0:
		
		if active and Input.is_action_pressed("up"):
			velocity.y += JUMP_GRAVITY * delta
		else:
			velocity.y += RAISE_GRAVITY * delta
	else:
		velocity.y += FALL_GRAVITY * delta
	
	
	var horizontal_input := (Input.get_action_strength("right") - Input.get_action_strength("left") if active else 0.0)
	
	
	if abs(horizontal_input) > 0:
		$Character.flip_h = horizontal_input < 0
		
		if sign(velocity.x) != sign(horizontal_input):
			velocity.x += horizontal_input * delta * DECCELERATION
		
		if is_on_floor():
			velocity.x += horizontal_input * delta * ACCELERATION
		else:
			velocity.x += horizontal_input * delta * ACCELERATION / 2
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
	
	
	var new_velocity = move_and_slide(velocity, Vector2.UP)
	
	for i in range(get_slide_count()):
		var collision = get_slide_collision(i)
		
		if collision.collider.has_method("move") and collision.normal == -velocity.normalized().snapped(Vector2.ONE):
			collision.collider.move(velocity)
	
	velocity = new_velocity
	
	animation_tree["parameters/conditions/jump_down"] = velocity.y > 0
	animation_tree["parameters/conditions/jump_up"] = velocity.y < 0
	animation_tree["parameters/conditions/moving"] = abs(horizontal_input) != 0.0
	animation_tree["parameters/conditions/not_moving"] = abs(horizontal_input) == 0.0
	animation_tree["parameters/conditions/on_floor"] = is_on_floor()


func can_jump():
	return is_on_floor()
	

func play_animation(animation: String) -> void:
	state_machine.travel(animation)


func play_sound(sound: String) -> void:
	if not ($AudioStreamPlayer2D.is_playing() and $AudioStreamPlayer2D.stream == sounds[sound]):
		$AudioStreamPlayer2D.stream = sounds[sound]
		$AudioStreamPlayer2D.play()

func transform() -> void:
	if transformed:
		state_machine.travel("transform_back")
		transformed = false
		manifestation.queue_free()
		manifestation = null
	else:
		state_machine.travel("transform")
		transformed = true
		velocity = Vector2()
		manifestation = preload("res://scenes/Manifestation.tscn").instance()
		get_parent().add_child(manifestation)
		if vertical_level == false:
			manifestation.position = position * Vector2(1, -1)
		if vertical_level == true:
			manifestation.position = position * Vector2(-1, 1)


func _on_SoundTimer_timeout() -> void:
	$SoundTimer.wait_time = rand_range(0.1, 0.2)
	$AudioStreamPlayer2D.pitch_scale = 1.0 + rand_range(-0.2, 0.2)
	$AudioStreamPlayer2D.play()





func _set_active(new_active: bool) -> void:
	active = new_active
	if new_active:
		$Tween.stop_all()
		$Tween.interpolate_property(self, "scale", scale, Vector2.ONE * 1.2, 0.1, Tween.TRANS_QUAD, Tween.EASE_OUT)
		$Tween.interpolate_property(self, "scale", Vector2.ONE * 1.2, Vector2.ONE, 0.1, Tween.TRANS_QUAD, Tween.EASE_IN, 0.1)
		$Tween.start()


func _set_texture(new_texture: Texture) -> void:
	texture = new_texture
	if has_node("Character"):
		$Character.texture = new_texture
