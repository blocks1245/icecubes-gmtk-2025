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
		
		currentState = "regular"
	
	if !regular.has_stream_playback():
		main_menu.stop()
		regular.play()

func playAnomaly():
	currentState = "anomaly"
	
	var rand = rng.randi_range(1, 3)
	
	match rand:
		1:
			AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Master"), 0, true)
		_:
			regular.pitch_scale = 1.2

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
