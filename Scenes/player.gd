class_name Jogador extends CharacterBody2D

signal tiro_laser(cena_laser, localizacao)
signal morreu()
signal player_respawn()

@onready var pos_laser_dir = $Laser_Direita_Marker
@onready var pos_laser_esq = $Laser_Esquerdo_Marker

@export var aceleracao = 500
@export var limite_municao = 25

var municao_dir = 25
var municao_esq = 25
var vida = 3

var cena_laser = preload("res://Scenes/laser.tscn")
@onready var Animate_dir = $Anim_Laser_Dir
@onready var Animate_esq = $Anim_Laser_Esq
@onready var Animate_shield = $ShieldAnim
@onready var timerShield = $Timer
@onready var timerCooldown = $CooldownEscudo
@onready var label_MunicaoDireita = $"HUDMunição/Control/MunicaoDireita"
@onready var label_MunicaoEsquerda = $"HUDMunição/Control/MunicaoEsquerda"
@onready var collision = $CollisionPolygon2D
@onready var label_vida = $HUDLife/Control/Vida
@onready var label_shield = $HUDLife/Control/Shield

var shield_enable = false
var shield_cooldown = false
var shield = 100
var respawn_enable = false

func _ready():
	Animate_shield.hide()
	Animate_dir.play("Booster")
	Animate_esq.play("Booster")
	_refresh_Vida_HUD()
	

func _process(delta):
	_refresh_Municao_HUD()
	_refresh_Shield_HUD()
	if !respawn_enable:
		if Input.is_action_just_pressed("tiro_direita"):
			if municao_dir > 0:
				atirar_direita()
				municao_dir -= 1
		if Input.is_action_just_pressed("tiro_esquerda"):
			if municao_esq > 0:
				atirar_esquerda()
				municao_esq -= 1
		if Input.is_action_just_pressed("escudo"):
			if shield == 100 and !shield_enable and !shield_cooldown:
				shield_enable = true
				Animate_shield.show()
				Animate_shield.play("Shield")
				timerShield.start()

func _physics_process(delta):
	var direção = Vector2(Input.get_axis("esquerda","direita"),Input.get_axis("cima","baixo"))
	
	velocity = direção * aceleracao
	move_and_slide()

func atirar_direita():
	tiro_laser.emit(cena_laser, pos_laser_dir.global_position)
	
func atirar_esquerda():
	tiro_laser.emit(cena_laser, pos_laser_esq.global_position)

func recarregar_municao(municao):
	for i in range(0,municao):
		if municao_dir < limite_municao:
			municao_dir += 1
		if municao_esq < limite_municao:
			municao_esq += 1

func morrer():
	if vida == 0:
		morreu.emit()
		queue_free()
	else:
		if !respawn_enable and !shield_enable:
			vida -= 1
			player_respawn.emit()
			_refresh_Vida_HUD()
		

func _on_timer_timeout():
	Animate_shield.hide()
	shield_enable = false
	timerCooldown.start()
	shield_cooldown = true

func _refresh_Vida_HUD():
	label_vida.text = "Vidas: "+str(vida)
	
func _refresh_Shield_HUD():
	if shield_cooldown:
		label_shield.text = "Shield in cooldown"
	elif shield_enable:
		label_shield.text = "Shield in use"
	else:
		label_shield.text = "Shield enable"
		

func _refresh_Municao_HUD():
	label_MunicaoDireita.text = str(municao_dir)+"/25"
	label_MunicaoEsquerda.text = str(municao_esq)+"/25"

func set_respawn_enable(value):
	respawn_enable = value	

func _on_cooldown_escudo_timeout():
	shield_cooldown = false
