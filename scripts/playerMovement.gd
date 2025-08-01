extends CharacterBody2D

@export var speed: int = 200 # Speed of the player
@export var jumpVelocity: int = 100 # Jump power of the player
@onready var right: bool = false # Is the player traveling to/from the left (false), or the right (true)? This is inelegant but it works

@export var gravity: int = 1470 # Export variable for gravity so we don't have to go in the project settings to change it

@onready var PlayerSprite: AnimatedSprite2D = $playerSprite #Variable for the player sprite (this will need to be changed when we animate it)

func _ready() -> void:
	update() # Update at the start so that the player is disabled and cannot interact with the menu

func _physics_process(delta) -> void: # Runs on each physics frame instead of each normal frame like _process to keep it regular regardless of device framerate
	#_handle_gravity(delta) # Calculate the velocity change from gravity
	#_handle_jumping() # Calculate the velocity change from jumping
	_handle_movement() # Calculate the velocity change from horizontal player movement
	_handle_animations()# handles the walking and idle animations of the player
	
	move_and_slide() #Move the player based on the velocity 
'''
func _handle_gravity(delta) -> void:
	if not is_on_floor(): # If the player is not on the floor
		velocity.y += gravity * delta # Add the gravity multiplied by time since the last frame to the vertical velocity

func _handle_jumping() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor(): #If jump pressed and the character is on the floor
		velocity.y -= jumpVelocity # Set the vertical velocity to the jump velocity
'''
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
	else: # If the game IS running
		visible = true # Make the player visible
		$Camera2D.enabled = true # Enable the player camera
		
func _handle_animations():
	if velocity.x != 0:
		PlayerSprite.play("walk_animation")
	else:
		PlayerSprite.play("idle_animation")
