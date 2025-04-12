extends TextureProgressBar

func _ready() -> void:
	$".".value = 0

func cycle_completed():
	if $".".value == $".".max_value:
		$".".value = $".".min_value
	else: 
		$".".value += 1
		# then flag row to be dropped
