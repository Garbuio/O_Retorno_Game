extends Area2D

@export var velocidade = 600
@onready var Animate = $AnimatedSprite2D

func _ready():
	Animate.play("Tiro")

func _physics_process(delta):
	global_position.y += -velocidade * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_area_entered(area):
	if area is Inimigo or area is Inimigo_Boss:
		area.morrer()
		queue_free()
		
