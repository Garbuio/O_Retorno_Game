extends Node2D

@export var inimigosRandom: Array[PackedScene] = []
@export var inimigoBoss: PackedScene

# Called when the node enters the scene tree for the first time.
@onready var jogador = $Jogador
@onready var pos_spawn_jogador = $SpawnJogador
@onready var laser_container = $LaserContainer
@onready var inimigos_container = $ContainerInimigos
@onready var inimigo_boss_container = $ContainerBoss
@onready var item_container = $ContainerItem
@onready var boss_container = $ContainerBoss
@onready var timer_respawn = $Respawn

var score = 0
var boss_spawned = false

@onready var scoreHud = $ScoreLayer/Control/Score
@onready var gameoverHub = $Gameover
@onready var label_score_gameover = $Gameover/Control/Panel/LabelScore
@onready var playerWin = $PlayerWin
@onready var label_score_win = $PlayerWin/Control/Panel/LabelScore

func _ready():
	jogador.global_position = pos_spawn_jogador.global_position
	jogador.tiro_laser.connect(_on_player_shot)
	jogador.player_respawn.connect(_player_respawn)
	jogador.morreu.connect(_jogador_morreu)
	scoreHud.text = "Pontuação: "+str(score)

func _jogador_morreu():
	gameoverHub.show()
	label_score_gameover.text = "Score: "+str(score)
	timer_respawn.stop()
	
func _boss_morreu():
	playerWin.show()
	label_score_win.text = "Score: "+str(score)

func _process(delta):
	if score >= 1500 and not boss_spawned:
		_criar_boss()

func _on_player_shot(cena_laser, localizacao):
	var laser = cena_laser.instantiate()
	laser.global_position = localizacao
	laser_container.add_child(laser)
	
func _criar_boss():
	boss_spawned = true
	var inimigoBoss_instantiate = inimigoBoss.instantiate()
	inimigoBoss_instantiate.global_position = Vector2(randf_range(20,1132), -150)
	inimigoBoss_instantiate.boss_morreu.connect(_boss_morreu)
	inimigo_boss_container.add_child(inimigoBoss_instantiate)

func _on_criar_inimigos_timeout_timeout():
	var inimigoEscolhido = inimigosRandom.pick_random().instantiate()
	inimigoEscolhido.global_position = Vector2(randf_range(20,1132), -10)
	inimigoEscolhido.spawn_item.connect(_spawn_item)
	inimigoEscolhido.inimigo_morreu.connect(_inimigo_morreu)
	inimigos_container.add_child(inimigoEscolhido)

func _spawn_item(cena_item, localizacao):
	var item = cena_item.instantiate()
	item.global_position = localizacao
	item.pegou_municao.connect(_recarregar_municao)
	item_container.add_child(item)

func _recarregar_municao(municao):
	jogador.recarregar_municao(municao)
	
func _inimigo_morreu(pontos):
	score += pontos
	scoreHud.text = "Pontuação: "+str(score)

func _player_respawn():
	jogador.global_position = pos_spawn_jogador.global_position
	jogador.modulate.a = 0.5
	jogador.set_respawn_enable(true)
	timer_respawn.start()

func _on_respawn_timeout():
	jogador.set_respawn_enable(false)
	jogador.modulate.a = 1
