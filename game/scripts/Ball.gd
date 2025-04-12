extends RigidBody2D
class_name Ball

var speed = 450
var move_velocity = Vector2.ZERO
var flying = false


@onready var player = get_tree().root.get_node("Game/Player")
var gm 

func _ready():
	position.x = player.position.x
	position.y = player.position.y - 75
	move_velocity.x = 0
	move_velocity.y = 0
	
func _enter_tree() -> void:
	gm = get_tree().root.get_node("Game/GameManager")
	
	
func _physics_process(delta):
	if flying:
		var collosion_object = move_and_collide(move_velocity * speed * delta)
		if collosion_object:
			
			#Bounce ball and update orientation
			var angle := move_velocity.angle_to_point(position)
			self.rotation = angle
			move_velocity = move_velocity.bounce(collosion_object.get_normal())
			
			#Get Collider (to see if its a brick and damage it)
			var collider = collosion_object.get_collider()
			if collider is Brick:
				collider.takeDamage(gm.damageArr[gm.ballLevel])
			
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
