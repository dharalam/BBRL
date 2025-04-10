extends CharacterBody2D

var speed = 200
var mouse_position = null

@onready var legs = $Legs
@onready var body = $Body
@onready var coffin = $Coffin



func _physics_process(delta):
	var direction = Input.get_axis("move_left", "move_right")
	
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
