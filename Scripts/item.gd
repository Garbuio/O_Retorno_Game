extends Area2D

signal pegou_municao(municao)
	
func _on_body_entered(body):
	if body is Jogador:
		pegou_municao.emit(5)
		queue_free()
		
