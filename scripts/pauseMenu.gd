extends Control

func _input(event) -> void:
	if Input.is_action_just_pressed("escape") and !visible and gameManager.running: # If you pressed escape when UI is not visible (aka not paused)
		visible = true # Make UI visible
		get_tree().paused = true # Pause the game
	
	elif Input.is_action_just_pressed("escape") and visible: # If you pressed the escape button when the UI is visible (aka paused)
		visible = false # Make it invisible
		get_tree().paused = false # Unpause the game


func _on_unpause_pressed() -> void:
	music.buttonPress() # Make button press sound
	
	visible = false # Make it invisible
	get_tree().paused = false # Unpause the game

func _on_return_to_main_pressed() -> void:
	music.buttonPress() # Make button press sound
	
	visible = false # Make it invisible
	get_tree().paused = false # Unpauses the game
	
	get_tree().change_scene_to_file("res://scenes/ui/mainMenu.tscn") # Swap to main menu scene

func _on_quit_pressed() -> void:
	get_tree().quit() # Quit game
