extends Area2D

var Enemy = preload("res://Scenes/Enemy.tscn")

var is_init = false
var hp = 100

func update():
	while true:
		yield(get_tree().create_timer(1), "timeout")
		spawn(1, 270-45, 200)
		spawn(1, 270+45, 200)
	
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
