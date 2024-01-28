extends Area2D

var scenes

func _on_body_entered(body):
	if body.name == "Player":
		get_tree().change_scene("res://scenes/"+scenes+".tscn")
	pass # Replace with function body.
