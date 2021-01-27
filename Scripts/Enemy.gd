extends Area2D

# 敵弾オブジェクト
var Bullet = preload("res://Scenes/Bullet.tscn")
var Particle = preload("res://Scenes/Particle.tscn")

var id = 0

# 体力
var hp = 5

# 初期化フラグ
var is_init = false

# 移動量
var velocity = Vector2()

var decay_time = 0
var past_time = 0
var destroy_time = -1

# 弾を撃つ
func bullet(deg, speed):
	var bullet = Bullet.instance()
	bullet.start(position.x, position.y, deg, speed)
	# ルートノードを取得
	var main_node = get_parent()
	main_node.add_child(bullet)
		
func start(eid, x, y, deg, speed):
	id = eid
	var hp_tbl = [0, 10, 10]
	var dst_tbl = [0, 3, 10]
	hp = hp_tbl[eid]
	destroy_time = dst_tbl[eid]
	
	position = Vector2(x, y)
	velocity.x = speed * cos(deg2rad(deg))
	velocity.y = speed * -sin(deg2rad(deg))

func hit(damage):
	# ダメージ処理
	hp -= damage
	if hp <= 0:
		# 消滅
		destroy()

func update():
	# 1秒ごとに弾を撃つテスト
	while true:
		yield(get_tree().create_timer(1), "timeout")
		bullet(270, 500)
	

func _ready():
	pass
	
func destroy():
	var p = Particle.instance()
	p.start(position.x, position.y, Color.green)
	var main_node = get_parent()
	main_node.add_child(p)
	queue_free()
	
func _physics_process(delta):
	if is_init == false:
		is_init = true
		update()

	if Global.isInScreen(self) == false:
		destroy()
	
	decay_time += 60 * delta
	while decay_time > 1:
		velocity *= 0.95
		decay_time -= 1
	
	# 移動	
	position += velocity * delta
	
	past_time += delta
	if past_time > destroy_time:
		# 自爆
		destroy()
