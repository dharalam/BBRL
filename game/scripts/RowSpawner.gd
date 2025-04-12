extends Node

class_name Row

const SHOP = 3 
const BOMB = 4
const CHARGE = 5

@export var brick_scene: PackedScene  
var brick_count := 0
var rowBricks = 0
var rowType = 0
var bombChance = 0 
var chargeChance = 0 
var shopRow = false

func _ready():
	spawn_bricks()

func spawn_bricks():
	var max_slots := 12
	var brick_width := 64
	var slots := []
	
	#generate random indicies to spawn bricks at 
	while slots.size() < rowBricks:
		var slot = randi_range(0, max_slots-1)
		if slot not in slots:
			slots.append(slot)
	slots.sort()
	
	#pick one index for a shop to appear 
	var shop_slot := -1
	if shopRow and slots.size() > 0:
		shop_slot = slots[randi_range(0, slots.size() - 1)]
	
	#Spawn bricks in designated spot
	for slot in slots:
		var brick = brick_scene.instantiate()
		brick.type = rowType   # Corresponding bricks
		# Determine if this brick should be a special type
		var rand := randi() % 100
		
		if shopRow and slot == shop_slot:
			brick.type = SHOP
		else:
			if rand < bombChance:
				brick.type = BOMB  
			elif rand < bombChance + chargeChance:
				brick.type = CHARGE 
			else:
				brick.type = rowType  #default to row type

		var x = slot * brick_width
		brick.position = Vector2(x, 0)
		add_child(brick)
		brick_count += 1
		brick.tree_exited.connect(_on_brick_removed)
	
func _on_brick_removed():
	brick_count -= 1
	print(brick_count)
	if brick_count <= 0:
		call_deferred("queue_free")
		
func move_down(amount := 100, duration := 0.3):
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", self.position + Vector2(0, amount), duration)
