extends Node

# Variables for max and min parameters
const MIN_MULT: float = 0.0
const MAX_MULT: float = 0.2

const MIN_SOFT: float = 0.6
const MAX_SOFT: float = 0.8

func edit(mult, soft): # Function to edit the shader properties
	$CanvasLayer/ColorRect.get_material().set_shader_parameter("multiplier", mult)
	$CanvasLayer/ColorRect.get_material().set_shader_parameter("softness", soft)

func calc() -> Array: # Calculate shader intensity from mistakes made
	var mistakes: float = gameManager.getMistakes() # Get mistakes
	var limit: float = settings.mistakesAllowed # Get max mistakes

	var soft: float = MAX_SOFT - ((mistakes/limit) * (MAX_SOFT-MIN_SOFT)) # Calculate the softness
	var mult: float = MAX_MULT - ((mistakes/limit) * (MAX_MULT-MIN_MULT)) # Calculate the multiplier
	# Okay so basically it's subtracing a percentage of the difference between the min and max from the max, reaching a minimum of the min, equal to the percentage of mistakes made from mistakes allowed
	
	# Catch out of bounds values (They shouldn't ever occur but it's good to catch unexpected bugs)
	if soft < MIN_SOFT:
		soft = MIN_SOFT
		
	elif soft > MAX_SOFT:
		soft = MAX_SOFT
	
	if mult < MIN_MULT:
		mult = MIN_MULT
		
	elif mult > MAX_MULT:
		mult = MAX_MULT
	
	return [mult, soft] # Return array of parameters to use
