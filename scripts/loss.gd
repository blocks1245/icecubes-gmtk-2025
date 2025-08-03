extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer # Animation player for fade

func _ready() -> void:
	gameManager.running = false # Unrender map and player and disable player camera
	player.update()
	map.update(null)
	
	music.fadeOut(music.regular, 2) # Fade out the music
	
	animation_player.play("FadeIn") # Start animation to fade back in from black
	await animation_player.animation_finished # Wait for the animation to finish (quite brief)

func _on_try_again_pressed() -> void:
	music.buttonPress() # Play button press sfx
	
	animation_player.play("FadeToBlack") # Start animation to fade back in from black
	await animation_player.animation_finished # Wait for the animation to finish (quite brief)
	
	gameManager.reset() # Reset round variables
	gameManager.running = true # Set game running
	
	# Switch to the first room
	get_tree().change_scene_to_file("res://scenes/%s" % gameManager.chooseRooms()[0])

func _on_main_menu_pressed() -> void:
	music.buttonPress() # Play button press sfx
	
	animation_player.play("FadeToBlack") # Start animation to fade back in from black
	await animation_player.animation_finished # Wait for the animation to finish (quite brief)
	
	get_tree().change_scene_to_file("res://scenes/ui/mainMenu.tscn") # Swap to main menu scene
