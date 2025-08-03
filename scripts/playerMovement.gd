extends CharacterBody2D

@export var speed: int = 200 # Speed of the player
@export var jumpVelocity: int = 100 # Jump power of the player
@onready var right: bool = false # Is the player traveling to/from the left (false), or the right (true)? This is inelegant but it works
@onready var inTween: bool = false # Bool for if the player is in a tween

@export var gravity: int = 1470 # Export variable for gravity so we don't have to go in the project settings to change it

@onready var PlayerSprite: AnimatedSprite2D = $playerSprite #Variable for the player sprite (this will need to be changed when we animate it)
@onready var walking: AudioStreamPlayer = $walking # Walk sfx (Why is this not in music? Great question, moving on...)

func _ready() -> void:
	update() # Update at the start so that the player is disabled and cannot interact with the menu

func _physics_process(delta) -> void: # Runs on each physics frame instead of each normal frame like _process to keep it regular regardless of device framerate
	#_handle_gravity(delta) # Calculate the velocity change from gravity
	#_handle_jumping() # Calculate the velocity change from jumping
	_handle_movement() # Calculate the velocity change from horizontal player movement
	_handle_animations()# handles the walking and idle animations of the player
	
	move_and_slide() #Move the player based on the velocity 

func _handle_movement() -> void:
	# Direction is basically -1 for left, +1 for right, as a float (null for no action)
	var direction = Input.get_axis("left", "right") 
	
	if direction: # If the direction is not null
		# Set the horizontal velocity of the player to their speed value in the direction specified
		velocity.x = direction * speed 
		
		if direction < 0: # If direction is negative (left)
			PlayerSprite.flip_h = true # Flip the sprite
		else: # If the direction is 0 (not possible) or positive (right)
			PlayerSprite.flip_h = false # Flip the sprite to the default
		
	else: # If the direction is null
		velocity.x = move_toward(velocity.x, 0, speed) # Smoothly move the velocity from the current velocity to 0 by the player's speed

func update() -> void: # Update the functionality of the player based on the status of the game
	if !gameManager.running: # If the game is NOT running
		visible = false # Make the player invisible
		$Camera2D.enabled = false # Disable the player camera
		
		gameManager.vignetteMultiplier = 0.2 # Set the vignette to factory menu settings
		gameManager.vignetteSoftness = 1.0
		
		vignette.edit(gameManager.vignetteMultiplier, gameManager.vignetteSoftness)
		
	else: # If the game IS running
		visible = true # Make the player visible
		$Camera2D.enabled = true # Enable the player camera
		
		gameManager.setVignette() # Set the vignette dynamically

func _handle_animations() -> void:
	if ((velocity.x != 0 or inTween) and gameManager.running) or (gameManager.inTut): # If velocity is not 0, or the player is in a tween or tutorial
		PlayerSprite.play("walk_animation") # Play walk animation and sfx
		walking.play(walking.get_playback_position())
	else: # Otherwise
		PlayerSprite.play("idle_animation") # Play idle animation and stop sfx
		walking.stop()
