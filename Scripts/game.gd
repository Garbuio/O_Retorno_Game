extends Node2D

@export var inimigosRandom: Array[PackedScene] = []

# Called when the node enters the scene tree for the first time.
@onready var jogador = $Jogador
@onready var pos_spawn_jogador = $SpawnJogador
@onready var laser_container = $LaserContainer
@onready var inimigos_container = $ContainerInimigos
@onready var item_container = $ContainerItem


func _ready():
	jogador.global_position = pos_spawn_jogador.global_position
	jogador.tiro_laser.connect(_on_player_shot)

func _on_player_shot(cena_laser, localizacao):
	var laser = cena_laser.instantiate()
	laser.global_position = localizacao
	laser_container.add_child(laser)
	
func _on_criar_inimigos_timeout_timeout():
	var inimigoEscolhido = inimigosRandom.pick_random().instantiate()
	inimigoEscolhido.global_position = Vector2(randf_range(20,1132), -10)
	inimigoEscolhido.spawn_item.connect(_spawn_item)
	inimigos_container.add_child(inimigoEscolhido)

func _spawn_item(cena_item, localizacao):
	var item = cena_item.instantiate()
	item.global_position = localizacao
	item.pegou_municao.connect(_recarregar_municao)
	item_container.add_child(item)

func _recarregar_municao(municao):
	jogador.recarregar_municao(municao)
