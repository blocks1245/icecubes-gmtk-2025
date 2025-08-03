extends Node

# The horrid variable block

@onready var availableRooms: Array = Array(DirAccess.get_files_at("res://scenes/rooms/")) # Get an array of all the possible rooms that can be chosen
@onready var UNIQUE_ANOMALIES: int = 1 # Just a constant for the number of unique anomalies implemented

@onready var rooms: Array = [] # Rooms that are actually active in this round
@onready var roomIndex: int = 0 # Index of the current room

@onready var tutorial: int = 0 # Variable for current tutorial stage
const tutorials: int = 4 # Constant for number of tutorial stages
@onready var tutIndices: Array = [] # Array of indices of tutorial scenes in rooms array
@onready var inTut: bool = false # Boolean for if a tutorial is active
@onready var textSpeed: float = 0.05 # Text speed variable

@onready var lines: Array = ["Darkness surrounds you...", 
"You can't find your parents.\nYou can't find anyone...",
"You can't keep your bearings.\nRooms seem to shift and swap as\nsoon as you lose sight of them,\nalmost as if you were lost in the Labyrinth of myth.\nBut no, it's just a creepy furniture store...",
"[TUTORIAL]\nYou HAVE picked up on one pattern...\nWhen the furnishing seems to change,\n or you hear something wrong\n TURN BACK!\nProceeding will only get you more lost...\n You hope you were paying attention to the rooms"] # Big array of dialogue lines for each tutorial page
@onready var firstLine: String = "Darkness surrounds you..."
@onready var firstLineVariant: String = "Lost in the dark..."

@onready var aStreak: int = 0 # Anomaly streak variable (negative for mundane streak)
@onready var streakMod: int = 20 # Percentage chance changed for each streak 

@onready var score: int = 0 # Score of the player (successful decisions)
@onready var mistakes: int = 0 # Number of failures/mistakes the player has made

@onready var vignetteMultiplier: float = 0.2 # Multiplier for vignette shader
@onready var vignetteSoftness: float = 1.0 # Softness for vignette shader

@onready var running: bool = false # Is the game currently running, or on a menu?

func addScore() -> void: # Increments the score upwards by 1
	score += 1

func resetScore() -> void: # Resets the score
	makeMistake() # This can only happen when a mistake is made, so call this as well
	score = 0 # Score to 0

func getScore() -> int: # Returns the score
	return score

func makeMistake() -> void: 
	roomIndex = 0 # Resets room index
	tutorial = 0 # Resets tutorial progress
	repairTutorials() # Repairs tutorials
	
	if score >= settings.roomsPerLoop: # If not in tutorial
		mistakes += 1 # Increment mistakes up
	
	setVignette() # Set the vignette shader based on current mistake counter

func getMistakes() -> int: # Returns the mistake counter
	return mistakes

func reset() -> void: # Resets all gameplay in the round, but maintains the room selection. Meant for after a full loss, if you choose to retry
	score = 0
	mistakes = 0
	roomIndex = 0
	_resetTutorials()
	
	player.right = false
	music.reset()

func chooseRooms() -> Array: # Select which rooms will be active
	rooms = [] # Empty the rooms array to begin, so that losing and restarting does not double the length of the game
	
	randomize() # Randomize the RNG seed for shuffle
	availableRooms.shuffle() # Shuffle the available rooms
	
	settings.maxmin() # Ensure that the number of rooms to select is not high or low enough to cause issues
	
	rooms.append("tut.tscn") # Add the initial tutorial scene
	tutIndices.append(rooms.size()-1) # Add the tutorial's index to the tracker
	
	for room in settings.roomsPerLoop: # For i rooms to select
		var filepath: String = availableRooms[room]
		filepath = filepath.replace('.remap', '') 
		
		rooms.append("rooms/" + filepath) # Add the first i rooms from availableRooms (which has been shuffled) into the active rooms array
		
		if (tutorial < tutorials): # If there are tutorials remaining
			rooms.append("tut.tscn") # Add another tutorial scene
			tutIndices.append(rooms.size()-1) # Add the index to the tracker
	
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

func updateAStreak(anomaly) -> void: # Update the anomaly streak
	if anomaly: # If it is an anomaly
		if aStreak < 0: # If the anomaly streak is negative (mundane streak)
			aStreak = 0 # Reset it
		else: # Otherwise, increase the streak
			aStreak =+ streakMod
	
	else: # If it is mundane
		if aStreak > 0: # If the streak is positive (anomaly streak)
			aStreak = 0 # Reset it
		else: # Otherwise, increase it negatively
			aStreak -= streakMod

func _resetTutorials() -> void: # Reset the tutorial progress and indices
	tutorial = 0
	tutIndices = []
	lines[0] = firstLine

func repairTutorials() -> void: # Repair tutorials after being popped
	popTutorials() # Pop them to clean it out

	for index in tutIndices: # For each saved index
		rooms.insert(index, "tut.tscn") # Insert a new tutorial at the correct position

func popTutorials() -> void: # Remove tutorials from the rooms array
	for room in range(rooms.size()-1, -1, -1): # Loop backwards through rooms
		if tutIndices.has(room) and rooms[room] == "tut.tscn": # If the room is in tutorial indices and is a tutorial (this is to make cleanup not destroy everything)
			rooms.remove_at(room) # Remove the room
			print('popped')
		
		roomIndex = 0 # Reset the current progress of the player since this will screw it up

func setVignette() -> void: # Set the vignette shader
	var vignetteSettings: Array = vignette.calc() # Get settings from vignette
	
	vignetteMultiplier = vignetteSettings[0] # Set the settings here to the calculated ones
	vignetteSoftness = vignetteSettings[1]
	
	vignette.edit(vignetteMultiplier, vignetteSoftness) # Set the vignette to saved settings
