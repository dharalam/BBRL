extends Node

class_name Row


@export var brick_scene: PackedScene  
var brick_count := 0

func _ready():
	spawn_bricks()

func spawn_bricks():
	for i in range(12):
		var brick = brick_scene.instantiate()
		brick.type = 1  # All bricks are of type 1
		brick.position = Vector2(i * 64, 0)  # Adjust spacing as needed
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
