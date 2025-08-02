extends Node

@onready var availableRooms: Array = Array(DirAccess.get_files_at("res://scenes/rooms/")) # Get an array of all the possible rooms that can be chosen
@onready var UNIQUE_ANOMALIES: int = 2 # Just a constant for the number of unique anomalies implemented

@onready var rooms: Array = [] # Rooms that are actually active in this round
@onready var roomIndex: int = 0 # Index of the current room

@onready var score: int = 0 # Score of the player (successful decisions)
@onready var mistakes: int = 0 #N umber of failures/mistakes the player has made
@onready var roomsEntered: int = 0

@onready var running: bool = false # Is the game currently running, or on a menu?

var repeatA: int # quick dirty fix to rooms repeating too much
var repeatR: int # im sorry if its ugly

func addScore() -> void: # Increments the score upwards by 1
	if roomsEntered >= settings.roomsPerLoop: # so that the first rooms dont count to the score and lets the map be cool score
		score += 1

func resetScore() -> void: # Resets the score
	score = 0 # Score to 0
	makeMistake() # This can only happen when a mistake is made, so call this as well

func getScore() -> int: # Returns the score
	return score

func makeMistake() -> void: # Increments the mistake counter upwards by 1
	roomIndex = 0 # 
	mistakes += 1
	roomsEntered += 1

func getMistakes() -> int: # Returns the mistake counter
	return mistakes

func reset() -> void: # Resets all gameplay in the round, but maintains the room selection. Meant for after a full loss, if you choose to retry
	score = 0
	mistakes = 0
	roomIndex = 0
	roomsEntered = 0
	player.right = false
	music.reset()

func chooseRooms() -> Array: # Select which rooms will be active
	rooms = [] # Empty the rooms array to begin, so that losing and restarting does not double the length of the game
	
	randomize() # Randomize the RNG seed for shuffle
	availableRooms.shuffle() # Shuffle the available rooms
	
	settings.maxmin() # Ensure that the number of rooms to select is not high or low enough to cause issues
	
	for room in settings.roomsPerLoop: # For i rooms to select
		rooms.append(availableRooms[room]) # Add the first i rooms from availableRooms (which has been shuffled) into the active rooms array
	
	return rooms # Return the selected rooms (basically builtin getRooms() since you'd want to call it anyways)

func advanceRoom() -> void: # Advance the room index
	if roomIndex >= rooms.size()-1: # If the room index is too large OR the user has failed and cannot progress, reset the room index to return to the start
		roomIndex = 0
	else: # Otherwise, increment the room index upwards by 1
		roomIndex += 1

func getRooms() -> Array: # Return the array of active rooms
	return rooms

func getRoomIndex() -> int: # Return the current room index
	return roomIndex
	
