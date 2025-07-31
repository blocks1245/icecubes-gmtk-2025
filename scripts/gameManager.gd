extends Node

@onready var score = 0
@onready var rooms = 3


func addScore(): #adds to the current score
	score += 1

func resetScore(): # resets the current score
	score = 0

func getScore(): # returns the score
	return score

func getRooms():# returns the number of roomsaaa
	return rooms
