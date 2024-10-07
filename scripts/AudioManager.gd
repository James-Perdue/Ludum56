extends Node

# Sound effect player nodes
var sfx_players = []
const MAX_SFX_PLAYERS = 8

# Music player node
var music_player: AudioStreamPlayer

# Dictionary to store preloaded audio streams
var audio_streams = {}

# Dictionary to store active tweens for each sfx player
var sfx_tweens = {}

# Volume settings
var master_volume = 1.0
var sfx_volume = 1.0
var music_volume = 1.0

func _ready():
	# Initialize sound effect players
	for i in range(MAX_SFX_PLAYERS):
		var player = AudioStreamPlayer.new()
		add_child(player)
		sfx_players.append(player)
		sfx_tweens[player] = null
	
	# Initialize music player
	music_player = AudioStreamPlayer.new()
	add_child(music_player)

# Preload audio files
func preload_audio(audio_name: String, file_path: String):
	var stream = load(file_path)
	if stream is AudioStream:
		audio_streams[audio_name] = stream

# Play a sound effect
func play_sfx(sfx_name: String):
	if sfx_name in audio_streams:
		for player in sfx_players:
			if not player.playing:
				player.stream = audio_streams[sfx_name]
				player.volume_db = linear_to_db(sfx_volume * master_volume)
				player.play()
				return
		print("Warning: All SFX players are busy. Sound not played: ", sfx_name)
	else:
		print("Error: Sound effect not found: ", sfx_name)

# Play a sound effect for a specified duration with fade in/out
func play_timed_sfx(sfx_name: String, duration: float, fade_in: float = 0.5, fade_out: float = 0.5):
	if sfx_name in audio_streams:
		for player in sfx_players:
			if not player.playing:
				player.stream = audio_streams[sfx_name]
				player.volume_db = -80  # Start silent
				player.play()
				
				var tween = create_tween()
				sfx_tweens[player] = tween
				
				# Fade in
				tween.tween_property(player, "volume_db", linear_to_db(sfx_volume * master_volume), fade_in)
				
				# Wait for the specified duration
				tween.tween_interval(duration - fade_in - fade_out)
				
				# Fade out
				tween.tween_property(player, "volume_db", -80, fade_out)
				
				# Stop the player and clear tween after fading out
				tween.tween_callback(func():
					player.stop()
					sfx_tweens[player] = null
				)
				
				return
		print("Warning: All SFX players are busy. Timed sound not played: ", sfx_name)
	else:
		print("Error: Sound effect not found: ", sfx_name)

# Stop all playing sound effects and clean up tweens
func stop_sfx(fade_out: float = 0.5):
	for player in sfx_players:
		if player.playing:
			# If there's an active tween, kill it
			if sfx_tweens[player]:
				sfx_tweens[player].kill()
			
			# Create a new tween for fading out
			var tween = create_tween()
			tween.tween_property(player, "volume_db", -80, fade_out)
			tween.tween_callback(func():
				player.stop()
				sfx_tweens[player] = null
			)

# Play background music
func play_music(music_name: String, fade_duration: float = 1.0):
	if music_name in audio_streams:
		var tween = create_tween()
		tween.tween_property(music_player, "volume_db", -80, fade_duration)
		tween.tween_callback(func():
			music_player.stream = audio_streams[music_name]
			music_player.volume_db = linear_to_db(music_volume * master_volume)
			music_player.play()
		)
	else:
		print("Error: Music not found: ", music_name)

# Stop the currently playing music
func stop_music(fade_duration: float = 1.0):
	var tween = create_tween()
	tween.tween_property(music_player, "volume_db", -80, fade_duration)
	tween.tween_callback(func():
		music_player.stop()
	)

# Set volume levels
func set_master_volume(volume: float):
	master_volume = clamp(volume, 0, 1)
	_update_volumes()

func set_sfx_volume(volume: float):
	sfx_volume = clamp(volume, 0, 1)
	_update_volumes()

func set_music_volume(volume: float):
	music_volume = clamp(volume, 0, 1)
	_update_volumes()

func _update_volumes():
	for player in sfx_players:
		if player.playing and not sfx_tweens[player]:
			player.volume_db = linear_to_db(sfx_volume * master_volume)
	music_player.volume_db = linear_to_db(music_volume * master_volume)
