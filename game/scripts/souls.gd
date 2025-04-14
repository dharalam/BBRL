extends Area2D
class_name Soul
var animations = {0: "standard_soul", 1: "halo_soul", 2: "angry_soul"}
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
var gm
var curr_value: int
var speed = 10

func _enter_tree() -> void:
	gm = get_tree().root.get_node("Game/GameManager")

func _ready() -> void:
	randomize()
	var randNum = randf() # Generate a random float between 0 and 1
	if randNum < 0.7:
		animated_sprite_2d.play(animations.get(0))
		curr_value = 1
	elif randNum < 0.85:
		animated_sprite_2d.play(animations.get(1))
		curr_value = 2
	else:
		animated_sprite_2d.play(animations.get(2))
		curr_value = -1
	speed = randi_range(7,13)
func move_down(amount := 10, duration := 0.3):
	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", self.position + Vector2(0, amount), duration)

func _on_body_shape_entered(body_rid: RID, body: Node, body_shape_index: int, local_shape_index: int) -> void:
	if body is Paddle:
		gm.souls = max(gm.souls + curr_value, 0)
		queue_free()

func _physics_process(delta: float) -> void:
	move_down(speed)
