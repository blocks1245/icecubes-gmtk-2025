extends Node

@onready var currentState = ""
@onready var rng = RandomNumberGenerator.new()

@onready var regular: AudioStreamPlayer = $regular
@onready var main_menu: AudioStreamPlayer = $mainMenu

var panner = AudioServer.get_bus_effect(AudioServer.get_bus_index("Master"), 1)

func playRegular():
	if currentState != "regular":
		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Master"), 0, false)
		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Master"), 1, false)
		regular.pitch_scale = 1.0
		main_menu.stop()
		regular.play()
		currentState = "regular"

func playAnomaly():
	if currentState != "anomaly":
		main_menu.stop()
		regular.play()
		var rand = rng.randi_range(1, 3)
		if rand == 1:
			AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Master"), 0, true)
		elif rand == 2:
			AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Master"), 1, true)
			panner.pan = rng.randf_range(-0.4, 0.4)
			if panner.pan > -0.25: # anything in between just sounds too much like the original to be reasonably differencible
				panner.pan = -0.25
			elif panner.pan < 0.25:
				panner.pan = 0.25
		else:
			regular.pitch_scale = rng.randf_range(1.03, 0.97)
			if regular.pitch_scale > 0.985:
				regular.pitch_scale = 0.985
			elif regular.pitch_scale < 1.015:
				regular.pitch_scale = 1.015
		currentState = "anomaly"

func stopAll():
	regular.stop()
	currentState = ""
	
func playMainMenu():
	if currentState != "main menu":
		regular.stop()
		main_menu.play()
		currentState = "main menu"
