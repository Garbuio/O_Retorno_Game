extends Area2D

@export var velocidade = 600

func _physics_process(delta):
	global_position.y += -velocidade * delta

func _on_visible_on_screen_notifier_2d_screen_exited():
	queue_free()