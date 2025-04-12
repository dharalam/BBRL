extends RigidBody2D
class_name Paddle

var speed = 250
var direction = 0 
@onready var legs = $Legs
@onready var body = $Body
@onready var coffin = $Coffin

func _ready() -> void:
	linear_velocity = Vector2.ZERO


func _process(delta):
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
		linear_velocity.x = direction * speed
	else:
		linear_velocity.x = move_toward(linear_velocity.x, 0, speed)


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	freeze = true

func _on_body_shape_exited(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	freeze = false
