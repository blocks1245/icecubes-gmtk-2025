extends Node

@onready var currentState: String = "" # Current room state
@onready var rng = RandomNumberGenerator.new() # RNG

@onready var regular: AudioStreamPlayer = $regular # Different songs/sfx (yeah it should be called sound not music but I sure as hell don't want to change all those calls)
@onready var main_menu: AudioStreamPlayer = $mainMenu
@onready var buzzing: AudioStreamPlayer = $buzzing
@onready var button: AudioStreamPlayer = $button
@onready var birds: AudioStreamPlayer = $birds

func _ready() -> void:
	buzzing.play() # Always play the buzzing

func fadeOut(song, duration) -> void: # Fade out a song
	var tween: Tween = create_tween() # Create a tween
	
	tween.tween_property(song, "volume_linear", 0, duration) # Make it bring the song to volume 0
	tween.play() # Play tween
	
	await tween.finished # Wait for it to end

func fadeIn(song, duration) -> void: # The same thing but to fade in, yes I should have just done another param
	var tween: Tween = create_tween()
	
	tween.tween_property(song, "volume_linear", 1, duration)
	tween.play()
	
	await tween.finished

func reset() -> void:
	for song in self.get_children(): # For each song
		if (song.volume_db): # Reset the song's volume
			song.volume_db = 0

func playRegular() -> void:
	if currentState != "regular": # If the current state is NOT regular
		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Master"), 0, false) # Reset bus
		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Master"), 1, false)
		regular.pitch_scale = 1.0 # And pitch
		
		currentState = "regular" # Set state to regular
	
	if !regular.has_stream_playback(): # If regular is not playing
		main_menu.stop() # Play it and stop other songs
		regular.play()

func playAnomaly() -> void:
	currentState = "anomaly" # Current state is set to anomaly
	rng.randomize() # Randomize the rng first to prevent patterns
	var rand = rng.randi_range(1, 2) # Randomize what will be anomalized
	
	match rand:
		1: # Didn't end up adding many, huh?
			AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Master"), 0, true) # Make it reverby
		_:
			regular.pitch_scale = 1.2 # Make it higher pitch (I think this actually makes it faster for some godforsaken reason)

func stopAll() -> void:
	regular.stop() # Stops all music (but not sfx lol, outdated)
	main_menu.stop()
	currentState = ""
	
func playMainMenu() -> void:
	if currentState != "main menu":
		regular.stop() # Stops regular
		main_menu.play() # Plays main menu
		currentState = "main menu"


func _on_main_menu_finished() -> void:
	if currentState == "main menu":
		main_menu.play() # Loop main menu (Is this even needed? I don't think it is, but I don't care to mess with it)


func _on_regular_finished() -> void:
	if currentState == "anomaly" or currentState == "regular":
		regular.play() # See above

func buttonPress() -> void:
	button.play() # Play button sfx

func playBirds() -> void:
	birds.play() # Play birds sfx

func stopBirds() -> void:
	birds.stop() # Stop birds sfx
