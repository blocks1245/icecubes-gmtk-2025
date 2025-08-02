extends AnimatedSprite2D

const HEIGHT: int = -32
@onready var frames = self.sprite_frames.get_frame_count("map")

func _ready() -> void:
	position.y = HEIGHT

func updateMap(exit, playerWidth, margin) -> void:
	if gameManager.roomsEntered > settings.roomsPerLoop and gameManager.running:
		visible = true
		
		if player.right == true:
			position.x = exit.position.x - playerWidth - margin
		else:
			position.x = exit.position.x + playerWidth + margin
	else:
		visible = false
	
	_setFrame()

func _setFrame() -> void:
	var goal: float = settings.roomsPerLoop * settings.loops
	var pos: float = gameManager.getScore()
	var frame: float = (pos/goal) * 7.0
	
	if frame < 0:
		frame = 0
		
	elif frame > 7:
		frame = 7
		
	else:
		frame = round(frame)
	
	set_frame(frame)
