extends Node2D

@onready var rng: RandomNumberGenerator = RandomNumberGenerator.new() # RNG object for randomization
@onready var animation_player: AnimationPlayer = $AnimationPlayer # Animation player for fading to and from black
@onready var propsFolder: Array = $Props.get_children() # Folder of all props that may be affected by anomalies

var anomaly: bool # Is the room an anomaly
var progress: bool # Is the player able to progress forwards

func _ready() -> void:
	rng.randomize() # Randomize the RNG seed to prevent repetition
	#player.
	if player.right == true: # If the player is entering through the right, place them on the right
		player.position.x = $rightExitArea/rightExitAreaCollider.position.x - 200
	else: # If the player is entering through the left, place them on the left
		player.position.x = $leftExitArea/leftExitAreaCollider.position.x + 200
	
	_generate_anomaly() # Roll to see if this room is an anomaly
	
	# This massive disgusting line of code is basically just debug output and will not remain
	print("Room: " + str(self.name) + " | anomaly ?: " + str(anomaly) + " | score: " + str(gameManager.getScore()) + " | mistakes: " + str(gameManager.getMistakes()))
	
	animation_player.play("FadeIn") # Start animation to fade back in from black
	await animation_player.animation_finished # Wait for the animation to finish (quite brief)

func _generate_anomaly() -> void:
	music.playRegular() # Default to regular music. This will carry into every room that does not then change the music via anomaly selection. This is here because it used to be under the section for rolling a non-anomaly room, but then it persists into consecutive anomaly rooms that it should not existent in
	
	if gameManager.getScore() > settings.roomsPerLoop-1: # If the current room is NOT in the first loop (which is for the user to observe the default states of each room)
		if rng.randi_range(0, 100) > 100 - settings.anomalyChance: # Roll to see if the room is an anomaly, based on percentage chance from settings
			anomaly = true # If successful, set the anomaly boolean to true
			_choose_anomaly() # Choose which anomaly will occur
		else: # If the room is not an anomaly
			anomaly = false # Set the anomaly boolean to false

func _on_right_exit_area_area_entered(_area: Area2D) -> void: # If the player touches the right exit
	await get_tree().physics_frame # Wait for a physics frame to avoid an error
	
	# Test if the player entered the correct side, and apply rewards or consequences
	_check_success(player.right, true) # Params are the side the player entered the room through, and the side they're exiting through (true = right, false = left)
	player.right = false # Player will be put on the left side in the next room
	
	_next_room() # Select and load the next room

func _on_left_exit_area_area_entered(_area: Area2D) -> void: # if you touch the left side
	await get_tree().physics_frame # Wait for a physics frame to avoid an error
	
	# Test if the player entered the correct side, and apply rewards or consequences
	_check_success(player.right, false) # Params are the side the player entered the room through, and the side they're exiting through (true = right, false = left)
	player.right = true # Player will be put on the right side in the next room
	
	_next_room() # sSelect and load the next room
	
func _check_success(entry, exit) -> void:
	if anomaly == true: # If the room is an anomaly
		if entry == exit: # If the player exited through the entrance door (backtracked)
			if !(gameManager.getScore() == settings.loops * settings.roomsPerLoop - 1): #If this is NOT the winning point (since if it is the winning point, similar to Exit 8, the room must not be an anomaly and the player must be moving forwards)
				gameManager.addScore() # Increase score by one
				
			gameManager.advanceRoom() # Increase the player's room index regardless
		
		else: # If the player left through the opposite door to their entrance
			gameManager.resetScore() # Reset their score, which also adds a mistake and resets their progress
	
	else: # If the room is NOT an anomaly
		if entry != exit: # If the player exited through the opposite door to their entrance
			gameManager.addScore() # Increase score by one
			
			gameManager.advanceRoom() # Increase the player's room index
		
		else: #If the player exited through their entry door (backtracked)
			gameManager.resetScore() # Reset their score, which also adds a mistake and resets their progress

func _next_room() -> void:
	animation_player.play("FadeToBlack") # Start animation to fade to black
	await animation_player.animation_finished # Wait for the animation to complete
	
	if gameManager.getMistakes() > settings.mistakesAllowed: # If more mistakes were made than allowed
		get_tree().change_scene_to_file("res://scenes/specialRooms/loss.tscn") # Send the player to the loss room
		return # Return so it does not then run the regular room advancement code
	
	if gameManager.getScore() >= (settings.roomsPerLoop * settings.loops): # If the player's score exceeds or equals the score needed to win
		get_tree().change_scene_to_file("res://scenes/specialRooms/win.tscn") # Send the player to the win room
		return # Return so it does not then run the regular room advancement code
	
	# Load the next room by index
	get_tree().change_scene_to_file("res://scenes/rooms/%s" % gameManager.rooms[gameManager.getRoomIndex()])

func _choose_anomaly() -> void:
	var anomalies: int = gameManager.UNIQUE_ANOMALIES + propsFolder.size() # Find the number of available anomalies
	var chosenAnomaly: int = rng.randi_range(1, anomalies) # Choose an anomaly from the available ones
	
	if chosenAnomaly <= propsFolder.size(): # If the chosen anomaly is one of the props
		var prop: AnimatedSprite2D = propsFolder[chosenAnomaly-1] # Find the corresponding prop sprite from index
		var frames: int = prop.frames.get_frame_count() # Find the number of frames (variants) of the prop
		
		var frame: int # Chosen frame/variant (just initialized here)
		
		if frames <= 1: # If this prop does not have anomaly frames for use
			_choose_anomaly() # Select a new anomaly
		else: # If this prop DOES have anomaly frames for use
			# Randomly choose one (There may only ever be one, but doesn't hurt to make it modular!)
			frame = rng.randi_range(1, frames-1) # 1 is the second frame (the first non-default), while frames-1 is the last one (-1 as it converts from index to size)
		
		prop.set_frame(frame) # Set the current frame of the prop to the chosen anomaly frame
	
	# The following are specific cases for unique anomalies. Not super elegant but it works
	else: # If the chosen anomaly is NOT one of the props
		match chosenAnomaly - propsFolder.size(): # Subtract all prop spaces from the anomaly to make it a predictable number
			1: # Case 1: Alternate music
				music.playAnomaly()
			2: # Case 2: Filler print output, just to have multiple cases for now
				print("hi i am an anomaly")
			_: # Default (none of the above)
				print("Critical error: an anomaly was generated but could not be chosen") # Output so we are aware if this happens unexpectedly, since it does resolve itself gameplay-wise
				_choose_anomaly() # Select a new anomaly, since something went wrong (usually UNIQUE_ANOMALIES being too large)
