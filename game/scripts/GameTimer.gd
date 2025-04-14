extends Node
@onready var timer: Timer = $Timer
@onready var animated_sprite_2d: AnimatedSprite2D = $Hourglass

func get_current_animation_length(animated_sprite: AnimatedSprite2D = animated_sprite_2d) -> float:
	var current_animation_name = animated_sprite.animation
	if current_animation_name == "":
		print("No animation is currently playing.")
		return -1.0

	var sprite_frames = animated_sprite.sprite_frames
	if sprite_frames and sprite_frames.has_animation(current_animation_name):
		var num_frames = sprite_frames.get_frame_count(current_animation_name)
		var absolute_time = 0
		for frame in range(num_frames):
			var anim_speed = sprite_frames.get_animation_speed(current_animation_name)
			absolute_time += sprite_frames.get_frame_duration(current_animation_name, frame) / (0.5 * abs(anim_speed))
		return absolute_time / 2
	else:
		print("Animation not found: ", current_animation_name)
		return -1.0

func _ready() -> void:
	timer.wait_time = get_current_animation_length()
	animated_sprite_2d.frame = 0
	animated_sprite_2d.play("Countdown")
	timer.start()
