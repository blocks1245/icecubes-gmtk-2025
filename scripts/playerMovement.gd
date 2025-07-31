extends CharacterBody2D

#Exported variables for the speed and jump velocity of the player
@export var speed = 500
@export var jumpVelocity = -500
@onready var right = false

#Get the gravity value for the project (I changed this because it looked liked we were on the moon)
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#Variable for the sprite itself (this will need to be changed when we animate it)
@onready var PlayerSprite = $PlayerSprite

#Runs on every physics frame instead of each normal frame like _process
func _physics_process(delta):
	if not is_on_floor(): #If the player is not on the floor
		velocity.y += gravity * delta #Add the gravity multiplied by time since the last frame
		
	if Input.is_action_just_pressed("jump") and is_on_floor(): #If jump pressed and on floor
		velocity.y = jumpVelocity #Set the vertical velocity to jump velocity
	
	#Direction is basically -1 for left, +1 for right, as a float (null for no action I believe)
	var direction = Input.get_axis("left", "right") 
	
	if direction: #If the direction is not null
		#Set the horizontal velocity of the player to their speed value in the direction specified
		velocity.x = direction * speed 
		
		if direction < 0: #If direction is negative (left)
			PlayerSprite.flip_h = true #Flip the sprite
		else: #If not (right)
			PlayerSprite.flip_h = false #Flip the sprite to the default
	else: #If the direction is null
		#Smoothly move the velocity from the current velocity to 0 using the speed
		velocity.x = move_toward(velocity.x, 0, speed)
		
	move_and_slide() #Move the player based on the velocity 
