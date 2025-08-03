extends AnimatedSprite2D

const HEIGHT: int = -32 # Height of map above y=0 (floor)
@onready var frames: float = float(self.sprite_frames.get_frame_count("map")) # Frames of map animation

func _ready() -> void:
	position.y = HEIGHT # Set y position to height

func update(pos) -> void:
	if gameManager.score >= settings.roomsPerLoop and gameManager.running: # If the player is not in the tutorial and the game is running
		visible = true # Make it visible
		position.x = pos # Set its position to the param (where the player exits the tween)
	else: # If tutorial or not running
		visible = false # Make it invisible
	
	_setFrame() # Set the map to the correct frame

func _setFrame() -> void:
	var goal: float = settings.roomsPerLoop * (settings.loops-1) # Goal/end of the map
	var pos: float = gameManager.getScore() - settings.roomsPerLoop # Current position
	var frame: float = (pos/(goal-1)) * frames # Frame is the percentage progressed multiplied by the total frames
	
	if frame < 0: # If the frame is too small, make it 0 
		frame = 0
		
	elif frame > frames: # If the frame is too large, make it the maximum
		frame = frames
		
	else: # Otherwise, just round it to the nearest whole number
		frame = round(frame)
	
	set_frame(frame) # Set the animated sprite's frame to the calculated one
