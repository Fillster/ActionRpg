extends CharacterBody2D

signal monster_targetted

var knockback = Vector2.ZERO

func _physics_process(delta):
	pass
	
func toggleTargetSprite():
	if $TargetSprite.visible == false:
		$TargetSprite.visible = true
	else:
		$TargetSprite.visible = false

func _on_area_2d_input_event(viewport, event, shape_idx):
	if  event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		print("lol it works")
		monster_targetted.emit()


func _on_monster_targetted():
	print("bajs")
	toggleTargetSprite()


func _on_hurtbox_area_entered(area):
	queue_free()
