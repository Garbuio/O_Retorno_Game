class_name Inimigo extends Area2D

signal spawn_item(item_cena, localizacao)
signal inimigo_morreu(points)

@export var velocidade = 150
@export var pontos = 50
@export var life = 1

var cena_item = preload("res://Scenes/item.tscn")

func _physics_process(delta):
	global_position.y += velocidade * delta

func morrer():
	life -= 1
	if life == 0:
		var itemRandom = randi_range(0,1000)
		inimigo_morreu.emit(pontos)
		if itemRandom > 800:
			spawn_item.emit(cena_item, global_position)
		queue_free()

func _on_body_entered(body):
	if body is Jogador:
		morrer()
		body.morrer()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
