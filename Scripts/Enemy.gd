extends Area2D

# 敵弾オブジェクト
var Bullet = preload("res://Scenes/Bullet.tscn")
var Particle = preload("res://Scenes/Particle.tscn")

var target = null

var id = 0
var id_previous = 0

# 体力
var hp = 5

# 初期化フラグ
var is_init = false

# 移動量
var velocity = Vector2()

var decay_time = 0
var past_time = 0
var destroy_time = -1
var _wait = 0

var func_ai = null

# 弾を撃つ
func bullet(deg, speed):
	var bullet = Bullet.instance()
	bullet.start(position.x, position.y, deg, speed)
	# ルートノードを取得
	var main_node = get_parent()
	main_node.add_child(bullet)
		
func start(eid, x, y, deg, speed):
	id = eid
	id_previous = id
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

func wait(t):
	_wait += t

func ai_1():
	# 1秒ごとに弾を撃つテスト
	while true:
		wait(1)
		yield()
		aim(500)	

func ai_2():
	# 1秒ごとに弾を撃つテスト
	while true:
		wait(0.5)
		yield()
		bullet(270, 100)	

func create_ai():
	match id:
		1:
			return ai_1()
		2:
			return ai_2()
		_:
			return ai_1()

func aim(spd):
	var deg = get_aim()
	bullet(deg, spd)
	
func get_aim():
	if is_instance_valid(target):
		# ターゲットが存在する
		var dx = target.position.x - position.x
		var dy = target.position.y - position.y
		return rad2deg(atan2(-dy, dx))
	else:
		# ターゲットが存在しない場合はマウス位置
		var dx = get_viewport().get_mouse_position().x - position.x
		var dy = get_viewport().get_mouse_position().y - position.y
		return rad2deg(atan2(-dy, dx))

func _ready():
	target = $"../Player"
	
func destroy():
	var p = Particle.instance()
	p.start(position.x, position.y, Color.mediumseagreen)
	var main_node = get_parent()
	main_node.add_child(p)
	queue_free()
	
func _physics_process(delta):
	
	if id != id_previous:
		# idが切り替わった
		is_init = false # 初期化し直す
		_wait = 0
	
	if is_init == false:
		# 初期化
		is_init = true
		func_ai = create_ai()
		
	_wait -= delta
	if _wait <= 0:
		func_ai = func_ai.resume()

	if Global.isInScreen(self) == false:
		destroy()
	
	decay_time += 60 * delta
	while decay_time > 1:
		velocity *= 0.95
		decay_time -= 1
	
	# 移動	
	position += velocity * delta
	
	past_time += delta
	if destroy_time > 0:
		if past_time > destroy_time:
			# 自爆
			destroy()
