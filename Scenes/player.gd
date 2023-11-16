extends CharacterBody2D

signal tiro_laser(cena_laser, localizacao)

@onready var pos_laser_dir = $Laser_Direita_Marker
@onready var pos_laser_esq = $Laser_Esquerdo_Marker
@export var aceleracao = 300

var cena_laser = preload("res://Scenes/laser.tscn")

func _process(delta):
	if Input.is_action_just_pressed("tiro_direita"):
		atirar_direita()
	if Input.is_action_just_pressed("tiro_esquerda"):
		atirar_esquerda()

func _physics_process(delta):
	var direção = Vector2(Input.get_axis("esquerda","direita"),Input.get_axis("cima","baixo"))
	
	velocity = direção * aceleracao
	move_and_slide()

func atirar_direita():
	tiro_laser.emit(cena_laser, pos_laser_dir.global_position)
	
func atirar_esquerda():
	tiro_laser.emit(cena_laser, pos_laser_esq.global_position)
