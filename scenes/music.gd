extends Node

@onready var currentState = ""

@onready var regular: AudioStreamPlayer = $regular
@onready var anomaly: AudioStreamPlayer = $anomaly

func playRegular():
	if currentState != "regular":
		anomaly.stop()
		regular.play()
		currentState = "regular"

func playAnomaly():
	if currentState != "anomaly":
		regular.stop()
		anomaly.play()
		currentState = "anomaly"

func stopAll():
	regular.stop()
	anomaly.stop()
	currentState = ""
