extends Area2D

# 移動方向
var velocity = Vector2()

# 開始
func start(x, y, deg, speed):
	position = Vector2(x, y)
	velocity.x = speed * cos(deg2rad(deg))
	velocity.y = speed * -sin(deg2rad(deg))

func _ready():
	pass

func _physics_process(delta):
	if Global.isInScreen(self) == false:
		# 画面外に出たので削除
		queue_free()
	
	position += velocity * delta

func _on_Bullet_area_entered(area):
	if area.name == "Player":
		area.hit(1) # プレイヤーに1ダメージ
		queue_free()
