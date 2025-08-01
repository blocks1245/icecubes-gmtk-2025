extends Node

@onready var loops: int = 4 # Number of loops to complete before winning the game
@onready var roomsPerLoop: int = 3 # Number of rooms per loop
@onready var mistakesAllowed: int = 3 # Number of mistakes allowed before a loss
@onready var anomalyChance: int = 70 # Chance in percentage of an anomaly occuring

func maxmin() -> void: #If roomsPerLoop is either too large or too small and will cause errors, reset it to the current maximum or minimum
	if roomsPerLoop > gameManager.availableRooms.size(): #If there are more rooms to choose than rooms available
		roomsPerLoop = gameManager.availableRooms.size() #Set rooms to choose to rooms available
	elif roomsPerLoop < 1: #If there are too few rooms to load any
		roomsPerLoop = 1 #Set rooms to choose to the minimum (one)
