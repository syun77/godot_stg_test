extends CPUParticles2D

func start(x, y, c):
	position = Vector2(x, y)
	color = c
	emitting = true

func _ready():
	pass # Replace with function body.

func _process(delta):
	if emitting == false:
		# 終了
		queue_free()
