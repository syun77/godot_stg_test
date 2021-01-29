extends Area2D

var Enemy = preload("res://Scenes/Enemy.tscn")
var Particle = preload("res://Scenes/Particle.tscn")

var is_init = false
var hp = 100
var maxhp = hp # 最大HP

func destroy():
	var p = Particle.instance()
	p.start(position.x, position.y, Color.green)
	var main_node = get_parent()
	main_node.add_child(p)
	queue_free()

func hit(damage):
	# ダメージ処理
	hp -= damage
	if hp <= 0:
		# 消滅
		destroy()

func update():
	while true:
		yield(get_tree().create_timer(1), "timeout")
		spawn(1, 270-45, 300)
		spawn(1, 270+45, 300)
		yield(get_tree().create_timer(2), "timeout")
		spawn(2, 0,   600)
		spawn(2, 180, 600)
		# 16方向に "3" を生成
		yield(get_tree().create_timer(1), "timeout")
		for i in range(16):
			var dir = i * 360 / 16
			spawn(3, dir, 300)
		
		# ワインダー
		yield(get_tree().create_timer(3), "timeout")
		spawn(4, 0,   500)
		spawn(4, 180, 500)
		
		yield(get_tree().create_timer(4), "timeout")
		spawn(5, 45,  400)
		spawn(5, 135, 400)
		
		yield(get_tree().create_timer(1.5), "timeout")
		spawn(6, 0,   500)
		spawn(6, 180, 500)
		
		yield(get_tree().create_timer(5), "timeout")

	
func spawn(eid, deg, spd):
	var e = Enemy.instance()
	e.start(eid, position.x, position.y, deg, spd)
	var main_node = get_owner()
	main_node.add_child(e)

func _ready():
	pass # Replace with function body.

func _hpratio():
	# 残りHPの割合を取得
	return 1.0 * hp / maxhp;

func _physics_process(delta):
	if is_init == false:
		update()
		is_init = true
		
	
	# HPバー更新
	var hpbar:TextureProgress = $"../HPBar"
	var hpratio = _hpratio()
	hpbar.value = 100 * hpratio
	
	# HPバーの色を更新
	hpbar.tint_progress = lerp(Color.red, Color.limegreen, hpratio)
