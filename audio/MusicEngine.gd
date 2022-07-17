extends Node

const CORRECTION = 0.25 # Music files are way too loud...

const FADE_DURATION = 1.0

const MAX_VOLUME = linear2db(0.8 * CORRECTION)
const MIXED_VOLUME = linear2db(0.5 * CORRECTION)
const MIN_VOLUME = linear2db(0.2 * CORRECTION)

var currently_playing: String

# array containing the music players
var players: Array

# these are needed to interpolate the propertier in the right direction
var upper_player: AudioStreamPlayer
var lower_player: AudioStreamPlayer

# Tween for interpolating the volumes
var tween: Tween


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS
	# two players are needed for blending between songs
	upper_player = create_player()
	upper_player.stream = preload("res://audio/songs/upper.wav")
	lower_player = create_player()
	lower_player.stream = preload("res://audio/songs/lower.wav")
	
	lower_player.play()
	upper_player.play()
	
	tween = Tween.new()
	add_child(tween)

func _process(delta):
	if Input.is_action_just_pressed("up"):
		play_upper()
	if Input.is_action_just_pressed("down"):
		play_lower()
	if Input.is_action_just_pressed("left"):
		play_equal()


func create_player() -> AudioStreamPlayer:
	var player = AudioStreamPlayer.new()
	player.volume_db = MIXED_VOLUME
	player.bus = "Music"
	players.append(player)
	add_child(player)
	
	return player



func play_upper() -> void:
	_fade(MIN_VOLUME, MAX_VOLUME)
func play_lower() -> void:
	_fade(MAX_VOLUME, MIN_VOLUME)
func play_equal() -> void:
	_fade(MIXED_VOLUME, MIXED_VOLUME)



func _fade(lower_volume: float, upper_volume: float) -> void:
	tween.stop_all()
	tween.interpolate_property(
		lower_player,
		"volume_db",
		lower_player.volume_db,
		lower_volume,
		FADE_DURATION
	)
	tween.interpolate_property(
		upper_player,
		"volume_db",
		upper_player.volume_db,
		upper_volume,
		FADE_DURATION
	)
	tween.start()
