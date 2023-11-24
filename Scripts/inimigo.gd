class_name Inimigo extends Area2D

@export var velocidade = 150

func _physics_process(delta):
	global_position.y += velocidade * delta

func morrer():
	queue_free()

func _on_body_entered(body):
	if body is Jogador:
		morrer()
		body.morrer()

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()
