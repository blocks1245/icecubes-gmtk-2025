extends Control

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape") and !visible: # if you pressed escape when UI is not visible (aka not paused)
		visible = true # make UI visible
		get_tree().paused = true # pause the game
	elif Input.is_action_just_pressed("escape") and visible: # if you pressed the escape button when the UI is visible (aka paused)
		visible = false # make it invisible
		get_tree().paused = false # unpause the game


func _on_unpause_pressed() -> void:
	visible = false # make  invisible agaim
	get_tree().paused = false # unpause the game

func _on_return_to_main_pressed() -> void:
	visible = false # make invisible again
	get_tree().paused = false #unpauses the game
	music.stopAll() # stops music
	gameManager.running = false # the game is no longer running
	player.update() # update player to not fuck up main menu
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn") # swap to main menu scene

func _on_quit_pressed() -> void:
	get_tree().quit() # quits game when button pressed
