extends Area2D

func _on_body_entered(body: Node) -> void:
	if body.name == "Player": 
		Global.win = true
		print("You win!")
