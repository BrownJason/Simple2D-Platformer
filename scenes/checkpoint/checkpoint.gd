class_name CheckPoint
extends Area2D

func _on_body_entered(body):
	if body is Player:
		call_deferred("level_complete")

func level_complete():
	get_parent().set_physics_process(false)
	
	if get_tree().current_scene is MainMenu:
		SceneManager.load_main_scene()
	else:
		SceneManager.load_next_level_scene()
	
