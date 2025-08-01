extends Node

@onready var currentState = ""
@onready var rng = RandomNumberGenerator.new()

@onready var regular: AudioStreamPlayer = $regular
@onready var main_menu: AudioStreamPlayer = $mainMenu

var panner = AudioServer.get_bus_effect(AudioServer.get_bus_index("Master"), 1)

func playRegular():
	if currentState != "regular":
		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Master"), 0, false) # gets reverb and turns it off
		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Master"), 1, false) # gets panning and turns it off
		regular.pitch_scale = 1.0 # sets pitch scale to normal
		main_menu.stop() # stops main menu music
		regular.play() # plays the track
		currentState = "regular"

func playAnomaly():
	if currentState != "anomaly":
		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Master"), 0, false) # resseting values in the event of 2 anomalies in a row that triggr music
		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Master"), 1, false) 
		regular.pitch_scale = 1.0 
		main_menu.stop() # stops main menu music
		regular.play() # plays the track
		var rand = rng.randi_range(1, 3) # in in 3 chance for 1 of 3 anomalies in the music
		if rand == 1:
			AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Master"), 0, true) # turn on a light reverb
		elif rand == 2:
			AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Master"), 1, true) # turn on panning
			panner.pan = rng.randf_range(-0.4, 0.4) # randomise the value for panning
			if panner.pan > -0.25: # anything in between just sounds too much like the original to be reasonably differencible
				panner.pan = -0.25
			elif panner.pan < 0.25:
				panner.pan = 0.25
		else:
			regular.pitch_scale = rng.randf_range(1.03, 0.97) # random pitch scale
			if regular.pitch_scale > 0.985: # anything in between sounds too much like the original
				regular.pitch_scale = 0.985
			elif regular.pitch_scale < 1.015:
				regular.pitch_scale = 1.015
		currentState = "anomaly"

func stopAll():
	regular.stop() # stops all music
	main_menu.stop()
	currentState = ""
	
func playMainMenu():
	if currentState != "main menu":
		regular.stop() # stops regular
		main_menu.play() # plays main meny
		currentState = "main menu"


func _on_main_menu_finished() -> void:
	if currentState == "main menu":
		main_menu.play() # loop main menu


func _on_regular_finished() -> void:
	if currentState == "anomaly" or currentState == "regular":
		regular.play() # loop regular
