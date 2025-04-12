extends RigidBody2D
class_name Ball

var speed = 400
var move_velocity = Vector2.ZERO
var flying = false
var damage = 500 
@onready var player = get_tree().root.get_node("Game/Player")
@onready var collision: CollisionShape2D = $Collision
var gm
var last_collider_id


func _ready():
	position.x = player.position.x
	position.y = player.position.y - 75
	move_velocity.x = 0
	move_velocity.y = 0
	
func _enter_tree() -> void:
	gm = get_tree().root.get_node("Game/GameManager")
	
	
func _physics_process(delta):
	if flying:
		var collision_object = move_and_collide(move_velocity * speed * delta)
		if collision_object:
			#Bounce ball and update orientation
			var angle := move_velocity.angle_to_point(position)
			self.rotation = angle
			if collision_object is Paddle or collision_object is Brick:
				move_velocity = ballCollision(collision_object)
			else:
				move_velocity = move_velocity.bounce(collision_object.get_normal())
			#Get Collider
			var obj = collision_object.get_collider()
			if obj is Brick:
			#if obj.has_method("takeDamage"):
				obj.takeDamage(damage)
			#print(obj.takeDamage(5))
	else:
		position.x = player.position.x
		if Input.is_action_just_pressed("active"):
			flying = true 
			move_velocity.y = -1
			move_velocity.x = player.direction
			var angle := move_velocity.angle_to_point(position)
			self.rotation = angle			
			
func isBallFlying(): #for determining if space bar is free for active power
	return flying

func ballCollision(collider) -> Vector2:
	var ball_width = collision.shape.get_rect().size.x
	var ball_center_x = position.x
	var collider_width = collider.shape.get_rect().size.x
	var collider_center_x = collider.position.x
	var velocity_xy = move_velocity.length()
	var collision_x = (ball_center_x - collider_center_x)/(collider_width/2)
	var new_velocity = Vector2.ZERO
	new_velocity.x = velocity_xy * collision_x
	if collider.get_rid() == last_collider_id && collider is Brick:
		new_velocity.x = new_velocity.rotated(deg_to_rad(randf_range(-45, 45))).x * 10
	else:
		last_collider_id = collider.get_rid()
	new_velocity.y = sqrt(absf(velocity_xy**2 - new_velocity.x**2)) * (-1 if move_velocity.y > 0 else 1)
	return new_velocity
	
		
	
