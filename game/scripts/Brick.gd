extends RigidBody2D
class_name Brick

@onready var brick1: AnimatedSprite2D = $Brick1
@onready var brick2: AnimatedSprite2D = $Brick2
@onready var brick3: AnimatedSprite2D = $Brick3
@onready var brickShop: AnimatedSprite2D = $BrickShop
@onready var brickBomb: AnimatedSprite2D = $BrickBomb	
@onready var brickCharge: AnimatedSprite2D = $BrickCharge
@onready var hit_box: CollisionShape2D = $HitBox
@onready var brick_break: AudioStreamPlayer2D = $BrickBreak


var soulContainer
var gm

var sprite
var maxhp = 8
var hp
var type = -1
enum brickTypes {BRICK1, BRICK2, BRICK3, BRICKSHOP, BRICKBOMB, BRICKCHARGE}

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
			sprite = brickBomb
			maxhp = 4
		brickTypes.BRICKCHARGE:
			sprite = brickCharge
			maxhp = 4
		_:
			queue_free()
			return
	hp = maxhp
	sprite.visible = true

func _enter_tree() -> void:
	soulContainer = get_tree().root.get_node("Game/SoulContainer")
	gm = get_tree().root.get_node("Game/GameManager")

func take_damage(dmg:float): 
	if type == brickTypes.BRICKBOMB or type == brickTypes.BRICKCHARGE:
		dmg = 1
		
	hp = hp - dmg
	if hp <= 0:
		break_brick()
		return 
	var perhp = hp / maxhp
	
	if perhp < 0.9 and perhp > 0.7:
		sprite.play("second")
	elif perhp <= 0.7 and perhp >= 0.5:
		sprite.play("third")
	elif perhp < 0.5 and perhp > 0.2:
		sprite.play("fourth") 
	
	
func break_brick():
	hit_box.disabled = true
	brick_break.play()
	sprite.play("break")


func _on_brick_animation_finished() -> void:
	sprite.visible = false
	var drop_soul = randf()
	if drop_soul <= 1.0:
		var soul_scene = load("res://scenes/Soul.tscn")
		var soul = soul_scene.instantiate()
		soulContainer.add_child(soul)
		soul.position = $".".global_position
		soul.position.x -= 90
	queue_free()

func _on_brick_shop_animation_finished() -> void:
	sprite.visible = false
	get_tree().paused = true
	get_tree().root.get_node("Game/Shop").show()
	queue_free()

func _on_brick_charge_animation_finished() -> void:
	gm.charge_active()
	sprite.visible = false
	queue_free()

func _on_brick_bomb_animation_finished() -> void:
	var neighbors = $BlastArea.get_overlapping_bodies()
	for neighbor in neighbors:
		if neighbor != self and neighbor is Brick:
			neighbor.take_damage(gm.damageArr[gm.ballLevel] * 3)

	sprite.visible = false
	queue_free()
