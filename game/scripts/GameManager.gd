extends Node

@export var row_container: Node2D
@export var ball_container: Node2D

const BRICKS_PER_REGION = 36
const ROWS_PER_REGION = 6 
enum powerTypes {NONE, MULTIBALL, FREEZE, SPEED, LIGHTNING}

var ballScene = preload("res://scenes/Ball.tscn")
var RowScene = preload("res://scenes/Row.tscn")

@onready var vboxr: VBoxContainer = $"../Souls Container"
@onready var player: Paddle = $"../Player"

var activeBalls = 1
var remainingBalls = 3 
var ballLevel = 0

var currentLevel = 0 
var souls = 0

var activeCD := 5.0 #seconds?
var tsA := 0.0 #time since active
var currentPower = powerTypes.FREEZE

var damageArr = [2, 4, 7, 14]
var chanceArr = [-20, 5, 8] #Shop, Bomb, Charge 

var remainingBricks = BRICKS_PER_REGION
var remainingRows = ROWS_PER_REGION 

signal update_balls
signal game_over

func create_row():
	#Move all existing row downs
	var rows_to_manage = row_container.get_children()
	for row in rows_to_manage:
		row.move_down()
		
	#Generate a new row, set the number of bricks to be some amount
	var row = RowScene.instantiate()
	row.rowType = currentLevel
	var rc = round(float(remainingBricks) / remainingRows) + randi_range(-2, 2)
	
	#if on the last row set it to the number of remaing
	#otherwise check that the amount of bricks were spawning is within bounds
	if remainingRows == 1:
		rc = remainingBricks 
	elif rc <= 0:
		rc = 1
	elif rc > 12:
		rc = 12 
	
	#Check if a shop spawn, if not increase odds on next row 
	var rand := randi() % 100
	print("Shop Chance: " + str(chanceArr[0])) 
	if rand < chanceArr[0]:
		row.shopRow = true
		chanceArr[0] = -20 #negative odds prevent back to back shop spawns
	else:
		chanceArr[0] = chanceArr[0] + 25 
		
	#Set the chance of bombs/charges, and the number of bricks in the row
	row.bombChance = chanceArr[1] 
	row.chargeChance = chanceArr[2]
	row.rowBricks = rc
	row_container.add_child(row)
	row.position = Vector2(50, 0)  # Set position (relative to row container)
	
	#Update Remaining bricks/rows
	remainingBricks = remainingBricks - rc 
	remainingRows = remainingRows - 1
	
	if remainingRows == 0:
		#if you hit the end of a region without seeing a shop in the last 5 rows you guarentee get one
		if chanceArr[0] >= 50:
			chanceArr[0] = 100 
		remainingRows = ROWS_PER_REGION
		remainingBricks = BRICKS_PER_REGION
		if currentLevel < 2: 
			currentLevel = currentLevel + 1 
		#Also update the background?

func _ready():
	randomize()
	create_row()
	
func _process(delta):
	tsA = tsA + delta
	if Input.is_action_just_pressed("active"):
		_handle_spacebar()

func charge_active():
	print("Active Charged")
	tsA = activeCD 
	
func activate_lightning():
	var rows = row_container.get_children()
	var bricks := []
	
	#iterates over all the rows and puts all their children into one array
	for row in rows:
		bricks.append_array(row.get_children())
		
	var count = round(bricks.size() * randf_range(0.2, 0.3)) #random percent of bricks
	if count < 1:
		count = 1
	
	var indices := [] 
	while indices.size() < count:
		var index = randi_range(0, bricks.size()-1)
		if index not in indices:
			indices.append(index)
			
	for index in indices:
		bricks[index].break_brick()
		
	tsA = 0.0


func activate_freeze(): 
	vboxr.pause_timer()
	await get_tree().create_timer(5.0).timeout
	vboxr.resume_timer()
	tsA = 0.0
	return
	
func activate_speed():
	var oldspeed = player.temp_speed
	player.speedup = true
	player.speed = player.speed * 2
	await get_tree().create_timer(2.0).timeout 
	player.speed = oldspeed
	player.speedup = true
	tsA = 0.0
	
func activate_multiball():
	activeBalls = activeBalls + 1
	spawn_extra_ball()
	print("Using Active!\n")
	tsA = 0.0
	
func spawn_extra_ball():
	for ball in ball_container.get_children():
		if ball.is_ball_flying():  
			var new_ball = ballScene.instantiate()
			new_ball.spawn_from_player = false  # Don't reset to paddle in _ready()
			new_ball.position = ball.position   # Spawn at the flying ball's location
			new_ball.move_velocity = ball.move_velocity  
			new_ball.flying = true       # Launch immediately
			ball_container.call_deferred("add_child", new_ball)
			return  # Only spawn one extra ball

	
func _handle_spacebar(): 	
	if _all_balls_flying():
		if tsA < activeCD:
			#provide feedback to the player for their active not being ready
			print("Power not ready")
			return
		else:
			match currentPower:
				powerTypes.NONE:
					#provide feedback to the player that they have no active 
					return
				powerTypes.MULTIBALL: 
					activate_multiball()
					print("multiball used!")
				powerTypes.FREEZE:
					activate_freeze()
					print("freeze used!")
				powerTypes.SPEED:
					activate_speed()
					print("speed used")
				powerTypes.LIGHTNING:
					activate_lightning()
				_:
					return
	else:
		print("launching balls")
		launch_ball_if_needed()

func launch_ball_if_needed():
	for ball in ball_container.get_children():
		if not ball.is_ball_flying():
			ball.launch_ball()	
	
func _all_balls_flying() -> bool:
	for ball in ball_container.get_children():
		if not ball.is_ball_flying():
			return false
	return true
	
func ballDrop():
	activeBalls = activeBalls - 1
	if activeBalls == 0:
		if remainingBalls == 0:
			game_over.emit()
			return
		else:
			remainingBalls -= 1
			activeBalls = 1
			update_balls.emit()
			print(remainingBalls)
			var instance = ballScene.instantiate()
			ball_container.call_deferred("add_child", instance)
