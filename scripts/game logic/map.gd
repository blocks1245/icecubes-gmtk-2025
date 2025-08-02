extends AnimatedSprite2D

func _physics_process(delta: float) -> void:
	if gameManager.roomsEntered > settings.roomsPerLoop:
		visible = true
	else:
		visible = false
	set_frame(gameManager.getScore())
