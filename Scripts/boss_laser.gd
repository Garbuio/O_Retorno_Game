class_name  Laser extends Area2D

@export var velocidade = 300
@onready var Animate = $AnimatedSprite2D

func _ready():
	Animate.play("big_bullet")

func _physics_process(delta):
	global_position.y += velocidade * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()

func _on_body_entered(body):
		body.morrer()
