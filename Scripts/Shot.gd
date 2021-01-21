extends RigidBody2D

func _ready():
	pass

func _process(delta):
	if position.y < 64:
		# 画面外に出たので削除
		queue_free()
