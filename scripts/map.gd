extends AnimatedSprite2D

func _physics_process(delta: float) -> void:
	set_frame(gameManager.getScore())
