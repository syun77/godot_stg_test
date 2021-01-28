extends CPUParticles2D

func start(x, y, c):
	# 位置を設定
	position = Vector2(x, y)
	
	# 色を設定
	color = c
	
	# 放出開始
	emitting = true

func _ready():
	pass # Replace with function body.

func _process(delta):
	if emitting == false:
		# 放出が終了
		queue_free()
