extends RigidBody2D

class_name Brick 

@onready var brick1: AnimatedSprite2D = $Brick1
@onready var brick2: AnimatedSprite2D = $Brick2
@onready var brick3: AnimatedSprite2D = $Brick3
@onready var brickShop: AnimatedSprite2D = $BrickShop
@onready var hit_box: CollisionShape2D = $HitBox

var sprite
var maxhp = 8
var hp
var type = -1
enum brickTypes {BRICK1, BRICK2, BRICK3, BRICKSHOP, BRICKBOMB}

func _ready():
	if type == -1:
		queue_free()
		return
	
	match type:
		brickTypes.BRICK1: 
			sprite = brick1
			maxhp = 8 
		brickTypes.BRICK2: 
			sprite = brick2
			maxhp = 14
		brickTypes.BRICK3: 
			sprite = brick3
			maxhp = 22
		brickTypes.BRICKSHOP: 
			sprite = brickShop
			maxhp = 4
		brickTypes.BRICKBOMB:
			sprite = brickShop
			maxhp = 4
		_:
			queue_free()
			return
	hp = maxhp
	sprite.visible = true

func takeDamage(dmg:float): 
	if type == brickTypes.BRICKBOMB:
		dmg = 1
		
	hp = hp - dmg
	if hp <= 0:
		breakBrick()
		return 
	var perhp = hp / maxhp
	
	if perhp < 0.9 and perhp > 0.7:
		sprite.play("second")
	elif perhp <= 0.7 and perhp >= 0.5:
		sprite.play("third")
	elif perhp < 0.5 and perhp > 0.2:
		sprite.play("fourth") 
	
	
func breakBrick():
	hit_box.disabled = true
	sprite.play("break")
	

func _on_brick_1_animation_finished() -> void:
	sprite.visible = false
	queue_free()

func _on_brick_2_animation_finished() -> void:
	sprite.visible = false
	queue_free()

func _on_brick_3_animation_finished() -> void:
	sprite.visible = false
	queue_free()

func _on_brick_shop_animation_finished() -> void:
	#TODO: do shop things
	sprite.visible = false
	queue_free()
