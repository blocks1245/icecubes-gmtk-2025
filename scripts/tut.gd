extends Node2D

@onready var animationPlayer: AnimationPlayer = $AnimationPlayer # Animation player for fading
@onready var out: Label = $tutUI/VBoxContainer/dialogue # Output dialogue box

@onready var finished: bool = false # Finished dialogue bool
@onready var switching: bool = false # Bool for if it's currently switching because if you spammed enter the game would crash

const DEFAULT_TEXT_SPEED: float = 0.05 # Constant for default text speed

func _ready() -> void:
	gameManager.running = false # Unrender player and map
	player.update()
	map.update(null)
	
	gameManager.inTut = true # Enable that you are in the tutorial
	gameManager.textSpeed = DEFAULT_TEXT_SPEED # Set text speped to the default
	
	music.playRegular() # Play regular music
	
	if gameManager.tutorial < gameManager.lines.size(): # If there are tutorials remaining (why does gameManager.tutorials not get it from here aghhhh)
		_scrollText(gameManager.lines[gameManager.tutorial]) # Play the tutorial text
	else: # Otherwise, it will show the default without scrolling animation and give an error (This should never happen!)
		print("Critical error: dialogue line '" + str(gameManager.tutorial) + "' does not exist.") 
	
	animationPlayer.play("FadeIn") # Start animation to fade back in from black
	await animationPlayer.animation_finished # Wait for the animation to finish (quite brief)

func _scrollText(string): # Scrolling text function
	out.text = "" # Out text
	for character in string: # For each character in the output string
		out.text += character # Add it to the output
		if gameManager.textSpeed > 0: # If there is a text speed
			await get_tree().create_timer(gameManager.textSpeed).timeout # Wait that speed for each letter
	
	finished = true # Set finished to true

func _input(_event) -> void: # When input is pressed
	if Input.is_action_just_pressed("enter") and finished and !switching: # When everything is ready to move on and enter pressed
		switching = true # Set switching to true to prevent doubling up on this
		
		animationPlayer.play("FadeToBlack") # Start animation to fade back in from black
		await animationPlayer.animation_finished # Wait for the animation to finish (quite brief)
		
		gameManager.tutorial += 1 # Advance tutorial counter
		gameManager.advanceRoom() # Advance room counter
		
		if (gameManager.tutorial >= gameManager.tutorials): # If all tutorials played
			gameManager.popTutorials() # Pop them out of the rooms array
			gameManager.lines[0] = gameManager.firstLineVariant
		
		gameManager.inTut = false # Tell the game you're not in tutorial anymore
		
		# Move to the next room
		get_tree().change_scene_to_file("res://scenes/%s" % gameManager.rooms[gameManager.getRoomIndex()])
	
	elif Input.is_action_just_pressed("enter") and !finished and !switching: # If it is not finished
		gameManager.textSpeed = 0 # Set textspeed to 0 to near instantly complete the scrolling
