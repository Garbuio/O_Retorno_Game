class_name Jogador extends CharacterBody2D

signal tiro_laser(cena_laser, localizacao)

@onready var pos_laser_dir = $Laser_Direita_Marker
@onready var pos_laser_esq = $Laser_Esquerdo_Marker

@export var aceleracao = 500
@export var limite_municao = 25

var municao_dir = 25
var municao_esq = 25

var cena_laser = preload("res://Scenes/laser.tscn")

func _process(delta):
	if Input.is_action_just_pressed("tiro_direita"):
		if municao_dir > 0:
			print("Direita: ",municao_dir)
			atirar_direita()
			municao_dir -= 1
	if Input.is_action_just_pressed("tiro_esquerda"):
		if municao_esq > 0:
			print("Esquerda: ",municao_esq)
			atirar_esquerda()
			municao_esq -= 1

func _physics_process(delta):
	var direção = Vector2(Input.get_axis("esquerda","direita"),Input.get_axis("cima","baixo"))
	
	velocity = direção * aceleracao
	move_and_slide()

func atirar_direita():
	tiro_laser.emit(cena_laser, pos_laser_dir.global_position)
	
func atirar_esquerda():
	tiro_laser.emit(cena_laser, pos_laser_esq.global_position)

func recarregar_municao(municao):
	for i in range(1,municao):
		if municao_dir < limite_municao:
			municao_dir += 1
		if municao_esq < limite_municao:
			municao_esq += 1

func morrer():
	queue_free()
