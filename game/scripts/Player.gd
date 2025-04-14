extends RigidBody2D
class_name Paddle

var speed = 250
var temp_speed
var speedup = false
var direction = 0 
@onready var legs = $Legs
@onready var bodySprite = $Body
@onready var coffin = $Coffin
@onready var hitbox: CollisionShape2D = $Hitbox


func _ready() -> void:
	linear_velocity = Vector2.ZERO

func _process(delta):
	#velocity = Vector2.ZERO	
	if speedup == false:
		temp_speed = speed
	direction = Input.get_axis("move_left", "move_right")
	
	if direction < 0: 
		legs.flip_h = false
		bodySprite.flip_h = false
		coffin.flip_h = false
	if direction > 0: 
		legs.flip_h = true
		bodySprite.flip_h = true
		coffin.flip_h = true
		
	if direction == 0:
		legs.play("standing")
	else: 
		legs.play("running")
		
		
	if get_tree().is_paused():
		# move paddle manually during pause
		var cap_shape = hitbox.shape as CapsuleShape2D
		var hitbox_half_width = (cap_shape.height + 2 * cap_shape.radius) / 4

		var left_border = get_tree().root.get_node("Game/WorldBoundries/LeftBorder").global_position.x
		var right_border = get_tree().root.get_node("Game/WorldBoundries/RightBorder").global_position.x
		
		var new_x = global_position.x + direction * speed * delta
		global_position.x = clamp(new_x, left_border + hitbox_half_width, right_border - hitbox_half_width)
		
		if Input.is_action_just_pressed("active"):
			get_tree().paused = false
			process_mode = Node.PROCESS_MODE_INHERIT	
	else:
		# normal RigidBody movement
		if direction:
			linear_velocity.x = direction * speed
		else:
			linear_velocity.x = move_toward(linear_velocity.x, 0, speed)
	#if direction:
	#	linear_velocity.x = direction * speed
	#else:
	#	linear_velocity.x = move_toward(linear_velocity.x, 0, speed)


func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	freeze = true

func _on_body_shape_exited(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	freeze = false
