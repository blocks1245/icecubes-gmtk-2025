extends AnimatedSprite2D

const HEIGHT: int = -32
@onready var frames = self.sprite_frames.get_frame_count("map")

func _ready() -> void:
	position.y = HEIGHT

func update(pos) -> void:
	if gameManager.score > settings.roomsPerLoop and gameManager.running:
		visible = true
		print("vis")
		position.x = pos
	else:
		visible = false
	
	_setFrame()

func _setFrame() -> void:
	var goal: float = settings.roomsPerLoop * (settings.loops-1)
	var pos: float = gameManager.getScore() - settings.roomsPerLoop
	var frame: float = (pos/goal) * 7.0
	
	if frame < 0:
		frame = 0
		
	elif frame > 7:
		frame = 7
		
	else:
		frame = round(frame)
	
	set_frame(frame)
