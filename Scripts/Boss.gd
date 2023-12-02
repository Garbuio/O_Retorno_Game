class_name Inimigo_Boss extends Area2D

signal boss_morreu()

@export var velocidade = 100
@export var velocidade_side = 300
@export var pontos = 50

@onready var timer = $Timer
@onready var bullet_container = $BulletContainer

var running = false
var rand: int
var vida = 20

var laser_item = preload("res://Scenes/boss_laser.tscn")

func _physics_process(delta):
	if global_position.y < 100:
		global_position.y += velocidade * delta
	else:
		if not running:
			rand = randi_range(0,100)
			timer.start()
			running = true
		if rand > 50:
			if global_position.x < 1140:
				global_position.x += velocidade_side * delta
		else:
			if global_position.x > 20:
				global_position.x -= velocidade_side * delta

func morrer():
	vida -= 1
	if vida == 0:
		boss_morreu.emit()
		queue_free()
		
func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_timer_timeout():
	running = false


func _on_bullet_timer_timeout():
	var bullet = laser_item.instantiate()
	bullet_container.add_child(bullet)


func _on_body_entered(body):
	if body is Jogador:
		body.morrer()
