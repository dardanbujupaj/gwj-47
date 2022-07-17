extends Node

const POOL_SIZE = 32

const sounds = {
	"UIHover": {
		"stream": preload("res://audio/effects/UI_Click_Metallic_mono.wav"),
		"volume": 0
	},
	"UIClick": {
		"stream":preload("res://audio/effects/UI_Click_Distinct_mono.wav"),
		"volume": 0
	},
}

# Called when the node enters the scene tree for the first time.
func _ready():
	pause_mode = Node.PAUSE_MODE_PROCESS
	for i in range(POOL_SIZE):
		var player = AudioStreamPlayer.new()
		player.bus = "Sound"
		add_child(player)


func _get_idle_player():
	for player in get_children():
		if not (player as AudioStreamPlayer).playing:
			return player

func play_sound(sound_name: String, intensity: float = 1.0):
	var audio_player: AudioStreamPlayer = _get_idle_player()
	if audio_player != null:
		var sound = sounds[sound_name]
		audio_player.stream = sound["stream"]
		audio_player.volume_db = linear2db(db2linear(sound["volume"]) * intensity)
		audio_player.play()
