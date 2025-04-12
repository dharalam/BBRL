extends RigidBody2D

class_name Brick 

@onready var brick1: AnimatedSprite2D = $Brick1
@onready var brick2: AnimatedSprite2D = $Brick2
@onready var brick3: AnimatedSprite2D = $Brick3
@onready var brickShop: AnimatedSprite2D = $BrickShop
@onready var hit_box: CollisionShape2D = $HitBox

var sprite
var maxhp = 10
var hp = maxhp
var type = -1

func _ready():
	if type == -1:
		queue_free()
		return
	
	match type:
		0: sprite = brick1
		1: sprite = brick2
		2: sprite = brick3
		3: sprite = brickShop
		_:
			queue_free()
			return
	#print("I have successfully been created!")
	sprite.visible = true

func takeDamage(dmg:float): 
	hp = hp - dmg
	if hp <= 0:
		breakBrick()
		return 
	var perhp = hp / maxhp
	
	if perhp < 0.9 and perhp > 0.7:
		sprite.play("second")
	elif perhp <= 0.7 and perhp > 0.5:
		sprite.play("third")
	elif perhp <= 0.5 and perhp > 0.2:
		sprite.play("fourth") 
	
	print("i took " + str(perhp) +" damage and have this much hp left" + str(hp))
	
func breakBrick():
	hit_box.disabled = true
	print("Brick Broken")
	sprite.play("break")
	

func _on_brick_1_animation_finished() -> void:
	print("animation done")
	sprite.visible = false
	queue_free()

func _on_brick_2_animation_finished() -> void:
	print("animation done")
	sprite.visible = false
	queue_free()

func _on_brick_3_animation_finished() -> void:
	print("animation done")
	sprite.visible = false
	queue_free()

func _on_brick_shop_animation_finished() -> void:
	print("animation done") #TODO: do shop things
	sprite.visible = false
	queue_free()
