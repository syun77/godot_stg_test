extends Area2D

var Enemy = preload("res://Scenes/Enemy.tscn")
var Particle = preload("res://Scenes/Particle.tscn")

var is_init = false
var hp = 100

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
		yield(get_tree().create_timer(3), "timeout")
		spawn(2, 0,   500)
		spawn(2, 180, 500)
		yield(get_tree().create_timer(5), "timeout")
	
func spawn(eid, deg, spd):
	var e = Enemy.instance()
	e.start(eid, position.x, position.y, deg, spd)
	var main_node = get_owner()
	main_node.add_child(e)

func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if is_init == false:
		update()
		is_init = true
