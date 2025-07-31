extends Control

func _physics_process(_delta: float) -> void:
	if Input.is_action_just_pressed("escape") and !visible:
		visible = true
		get_tree().paused = true
	elif Input.is_action_just_pressed("escape") and visible:
		visible = false
		get_tree().paused = false


func _on_unpause_pressed() -> void:
	visible = false
	get_tree().paused = false


func _on_quit_pressed() -> void:
	get_tree().quit()
