extends CharacterBody2D

const ACCELERATION = 30
const MAX_SPEED = 150
#const FRICTION = 500
const FRICTION: float = 0.25

enum {
	MOVE,
	ROLL,
	ATTACK
}
var state = MOVE

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@export var displayName = ""
@onready var animationState = animationTree.get("parameters/playback")


## check if mouse is inside enemy collision shape. 
## emit signal 

func _ready():
	animationTree.active = true
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	$PlayerName.text = $".".displayName

#func _input(event):
   # Mouse in viewport coordinates.
#	if event is InputEventMouseButton:
	#	print("Mouse Click/Unclick at: ", event.position)
	#elif event is InputEventMouseMotion:
		#print("Mouse Motion at: ", event.position)

func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		match state:
			MOVE:
				move_state(delta)
			ROLL:
				pass
			ATTACK:
				attack_state(delta)


func move_state(delta):
	#if Input.is_action_pressed("LeftClick"):
			#print("Player Click")
			
		#get_input()
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		#animationPlayer.play("RunRight")
		#updateAnimation()
		if input_dir != Vector2.ZERO:
			animationTree.set("parameters/Idle/blend_position", input_dir)
			animationTree.set("parameters/Run/blend_position", input_dir)
			animationTree.set("parameters/Attack/blend_position", input_dir)
			animationState.travel("Run")
		else:
			animationState.travel("Idle")
		
		velocity = lerp(velocity, Vector2.ZERO, FRICTION)
		velocity += input_dir * ACCELERATION
		velocity = velocity.limit_length(MAX_SPEED)
		move_and_slide()
		
		if Input.is_action_just_pressed("Attack"):
			state = ATTACK


func attack_state(delta):
	velocity = Vector2.ZERO
	animationState.travel("Attack")

func attack_animation_finished():
	state = MOVE
