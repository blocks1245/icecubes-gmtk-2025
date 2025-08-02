extends Node

@onready var currentState: String = ""
@onready var rng = RandomNumberGenerator.new()

@onready var regular: AudioStreamPlayer = $regular
@onready var main_menu: AudioStreamPlayer = $mainMenu
@onready var buzzing: AudioStreamPlayer = $buzzing
@onready var button: AudioStreamPlayer = $button

var panner: AudioEffect = AudioServer.get_bus_effect(AudioServer.get_bus_index("Master"), 1)

func _ready() -> void:
	buzzing.play()

func fadeOut(song, duration) -> void:
	var tween: Tween = create_tween()
	
	tween.tween_property(song, "volume_linear", 0, duration)
	tween.play()
	
	await tween.finished

func reset() -> void:
	for song in self.get_children():
		if (song.volume_db):
			song.volume_db = 0

func playRegular() -> void:
	if currentState != "regular":

		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Master"), 0, false)
		AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Master"), 1, false)
		regular.pitch_scale = 1.0
		
		currentState = "regular"
	
	if !regular.has_stream_playback():
		main_menu.stop()
		regular.play()

func playAnomaly() -> void:
	currentState = "anomaly"
	
	var rand = rng.randi_range(1, 3)
	
	match rand:
		1:
			AudioServer.set_bus_effect_enabled(AudioServer.get_bus_index("Master"), 0, true)
		_:
			regular.pitch_scale = 1.2

func stopAll() -> void:
	regular.stop() # stops all music
	main_menu.stop()
	currentState = ""
	
func playMainMenu() -> void:
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

func buttonPress() -> void:
	button.play()
