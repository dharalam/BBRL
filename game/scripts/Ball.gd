extends RigidBody2D
class_name Ball

var speed = 400
var move_velocity = Vector2.ZERO
var flying = false
var auto_launch = false
var spawn_from_player = true

@onready var player = get_tree().root.get_node("Game/Player")
@onready var collision: CollisionShape2D = $Collision
@onready var ballstrike: AudioStreamPlayer2D = $Ballstrike

var gm
var last_collider_id


func _ready():
	lock_rotation = true

	if spawn_from_player: 
		position = player.position + Vector2(0, -75)	
		move_velocity = Vector2.ZERO
	
	if auto_launch:
		launch_ball()
	
func _enter_tree() -> void:
	gm = get_tree().root.get_node("Game/GameManager")
	
func launch_ball():
	flying = true 
	move_velocity = Vector2(player.direction, -1).normalized()
	var angle := move_velocity.angle_to_point(position)
	self.rotation = angle			

func _physics_process(delta):
	if flying:
		var collision_object = move_and_collide(move_velocity * speed * delta)
		if collision_object:
			#Bounce ball and update orientation
			var angle := move_velocity.angle_to_point(position)
			self.rotation = angle
			ballstrike.play()
			if collision_object is Paddle:
				#move_velocity = paddle_bounce(collision_object)
				move_velocity = move_velocity.bounce(collision.object.get_normal())
			elif collision_object is Brick:
				move_velocity = move_velocity.bounce(collision_object.get_normal()).rotated(deg_to_rad(randf_range(-7.5, 7.5)))
			else:
				move_velocity = move_velocity.bounce(collision_object.get_normal()).rotated(deg_to_rad(randf_range(-10, 10)))
			
			move_velocity = move_velocity.normalized() 
			
			#Get Collider
			var obj = collision_object.get_collider()
			if obj is Brick:
				obj.take_damage(gm.damageArr[gm.ballLevel])
	else:
		position.x = player.position.x
			
func is_ball_flying():
	return flying
	
#func paddle_bounce(collider) -> Vector2:
#	var ball_width = collision.shape.get_rect().size.x
#	var ball_center_x = position.x
#	var collider_width = collider.shape.get_rect().size.x
#	var collider_center_x = collider.position.x
#	var velocity_xy = move_velocity.length()
#	var collision_x = (ball_center_x - collider_center_x)/(collider_width/2)
#	var new_velocity = Vector2.ZERO
#	new_velocity.x = velocity_xy * collision_x
#	if collider.get_rid() == last_collider_id && collider is Brick:
#		new_velocity.x = new_velocity.rotated(deg_to_rad(randf_range(-45, 45))).x * 10
#	else:
#		last_collider_id = collider.get_rid()
#	new_velocity.y = sqrt(absf(velocity_xy**2 - new_velocity.x**2)) * (-1 if move_velocity.y > 0 else 1)
#	return new_velocity
	
		
#func paddle_bounce(collider) -> Vector2:
#	
#	var paddle_width = collider.shape.get_rect().size.x
#	var hit_offset = (position.x - collider.position.x) / (paddle_width / 2)
#
#	# Clamp hit_offset to [-1, 1]
#	hit_offset = clamp(hit_offset, -1.0, 1.0)
#
#	# Max bounce angle (in degrees) from vertical
#	var max_bounce_angle = 75
#
#	# Convert hit_offset to angle
#	var bounce_angle = deg_to_rad(hit_offset * max_bounce_angle)
#
#	# Generate bounce direction
#	var new_velocity = Vector2(sin(bounce_angle), -cos(bounce_angle)) * move_velocity.length()
#	return new_velocity
#	
#func paddle_bounce(collider) -> Vector2:
#	var ball_width = collision.shape.get_rect().size.x
#	var ball_center_x = position.x
#	var collider_width = collider.shape.get_rect().size.x
#	var collider_center_x = collider.position.x
#	
#	var velocity_xy = move_velocity.length()
#
#	# Compute offset from center (-1 to 1)
#	var offset = (ball_center_x - collider_center_x) / (collider_width / 2)
#	offset = clamp(offset, -1.0, 1.0)
#
#	# Exaggerate the bounce based on how far from center it hits
#	var angle_offset = offset * deg_to_rad(80)  # Up to 60 degrees curve
#	var new_angle = -PI / 2 + angle_offset  # Straight up is -PI/2
#
#	var new_velocity = Vector2.RIGHT.rotated(new_angle) * velocity_xy
#	return new_velocity
