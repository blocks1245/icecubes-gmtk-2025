extends CharacterBody2D

@export var speed = 600

func get_input():
	look_at(get_global_mouse_position())
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	
func _physics_process(delta: float) -> void:
	get_input()
	move_and_slide()
