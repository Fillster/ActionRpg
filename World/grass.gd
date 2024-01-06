extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func create_grass_effect():
	var GrassEffectScene = load("res://Effects/grass_effect.tscn")
	var instance = GrassEffectScene.instantiate()
	get_parent().add_child(instance)
	instance.global_position = global_position




func _on_hurtbox_area_entered(area):
	create_grass_effect()
	queue_free()
