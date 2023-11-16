extends Node2D

# Called when the node enters the scene tree for the first time.
@onready var jogador = $Jogador
@onready var pos_spawn_jogador = $SpawnJogador
@onready var laser_container = $LaserContainer


func _ready():
	jogador.global_position = pos_spawn_jogador.global_position
	jogador.tiro_laser.connect(_on_player_shot)

func _on_player_shot(cena_laser, localizacao):
	var laser = cena_laser.instantiate()
	laser.global_position = localizacao
	laser_container.add_child(laser)
