extends CharacterBody2D
class_name Paddle
<<<<<<< Updated upstream
var speed = 250
=======

var speed = 200
>>>>>>> Stashed changes
var direction = 0 
@onready var legs = $Legs
@onready var body = $Body
@onready var coffin = $Coffin


func _physics_process(delta):
	#velocity = Vector2.ZERO	
	direction = Input.get_axis("move_left", "move_right")
	
	if direction < 0: 
		legs.flip_h = false
		body.flip_h = false
		coffin.flip_h = false
	if direction > 0: 
		legs.flip_h = true
		body.flip_h = true
		coffin.flip_h = true
		
	if direction == 0:
		legs.play("standing")
	else: 
		legs.play("running")
		
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)

	move_and_slide()
