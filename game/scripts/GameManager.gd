extends Node

@export var row_container: Node2D
@onready var player = $"../Player"
var ballScene = preload("res://scenes/Ball.tscn")
var RowScene = preload("res://scenes/Row.tscn")
var activeBalls = 1
var remainingBalls = 3 
var souls = 0

@onready var game: Control = $".."
signal update_balls

func create_row():
	var rows_to_manage = row_container.get_children()
	for row in rows_to_manage:
		row.move_down()
	var row = RowScene.instantiate()
	row_container.add_child(row)
	row.position = Vector2(50, 0)  # Set start position

func _ready():
	print("RowScene loaded:", RowScene)
	create_row()	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func ballDrop():
	activeBalls = activeBalls - 1
	if activeBalls == 0:
		remainingBalls -= 1
		activeBalls = 1
		update_balls.emit()
		print(remainingBalls)
		var instance = ballScene.instantiate()
		game.call_deferred("add_child", instance)
	if remainingBalls == 0:
		pass #TODO: Game over logic
