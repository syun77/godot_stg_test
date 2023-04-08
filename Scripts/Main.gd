extends Node2D

@onready var _boss    = $Boss
@onready var _player  = $Player
@onready var _caption = $Label

func _ready():
	DisplayServer.window_set_size((Vector2i(480*2, 720*2)))
	
	Common.enemies = $Enemies
	Common.bullets = $Bullets


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	Global.set_target(_player)
	
	if is_instance_valid(_player) == false:
		_caption.text = "GAME OVER\n\nPRESS SPACE KEY"
		if Input.is_action_just_pressed("ui_select"):
			# リスタート
			get_tree().change_scene_to_file("res://Scenes/Main.tscn")
	elif is_instance_valid(_boss) == false:
		for n in get_children():
			if "Enemy" in n.name or "Bullet" in n.name:
				n.hit(9999)
		_caption.text = "YOU WIN\n\nPRESS SPACE KEY"
		if Input.is_action_just_pressed("ui_select"):
			# リスタート
			get_tree().change_scene_to_file("res://Scenes/Main.tscn")
