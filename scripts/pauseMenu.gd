extends Control

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape") and !visible:
		visible = true
		get_tree().paused = true
	elif Input.is_action_just_pressed("escape") and visible:
		visible = false
		get_tree().paused = false


func _on_unpause_pressed() -> void:
	visible = false # make 
	get_tree().paused = false

func _on_return_to_main_pressed() -> void:
	get_tree().paused = false #unpauses the game
	music.stopAll() # stops music
	gameManager.running = false # the game is no longer running
	player.update() # update player to not fuck up main menu
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn") # swap to main menu scene

func _on_quit_pressed() -> void:
	get_tree().quit() # quits game when button pressed
