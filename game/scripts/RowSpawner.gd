extends Node

class_name Row


@export var brick_scene: PackedScene  
var brick_count := 0
var rowBricks = 0
var rowType = 0

func _ready():
	spawn_bricks()

func spawn_bricks():
	var max_slots := 12
	var brick_width := 64
	var slots := []
	
	while slots.size() < rowBricks:
		var slot = randi_range(0, max_slots-1)
		if slot not in slots:
			slots.append(slot)
	slots.sort()
	for slot in slots:
		var brick = brick_scene.instantiate()
		brick.type = rowType   # Corresponding bricks
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
