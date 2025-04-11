extends Node

@onready var player = $"../Player"
var ballScene = preload("res://scenes/Ball.tscn")
var activeBalls = 1
var remainingBalls = 3 

func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func ballDrop():
	activeBalls = activeBalls - 1
	if activeBalls == 0:
		remainingBalls = remainingBalls - 1
		activeBalls = 1
		var instance = ballScene.instantiate()
		add_child(instance)
	
