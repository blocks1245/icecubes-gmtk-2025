extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready() -> void:
	#Remove these lines to add cutscene
	gameManager.running = false
	player.update()
	
	music.fadeOut(music.regular, 2)
	music.fadeOut(music.buzzing, 5)
	
	animation_player.play("FadeIn") # Start animation to fade back in from black
	await animation_player.animation_finished # Wait for the animation to finish (quite brief)

func _on_try_again_pressed() -> void:
	animation_player.play("FadeToBlack") # Start animation to fade back in from black
	await animation_player.animation_finished # Wait for the animation to finish (quite brief)
	
	gameManager.reset()
	gameManager.running = true
	
	get_tree().change_scene_to_file("res://scenes/rooms/%s" % gameManager.rooms[gameManager.getRoomIndex()])

func _on_main_menu_pressed() -> void:
	music.stopAll() # stops music
	gameManager.running = false # the game is no longer running
	player.update() # update player to not fuck up main menu
	
	animation_player.play("FadeToBlack") # Start animation to fade back in from black
	await animation_player.animation_finished # Wait for the animation to finish (quite brief)
	
	get_tree().change_scene_to_file("res://scenes/mainMenu.tscn") # swap to main menu scene
