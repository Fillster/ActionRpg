extends CharacterBody2D

const ACCELERATION = 30
const MAX_SPEED = 150
#const FRICTION = 500
const FRICTION: float = 0.25

@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@export var displayName = ""
@onready var animationState = animationTree.get("parameters/playback")


func _ready():
	$MultiplayerSynchronizer.set_multiplayer_authority(str(name).to_int())
	$PlayerName.text = $".".displayName


func _physics_process(delta):
	if $MultiplayerSynchronizer.get_multiplayer_authority() == multiplayer.get_unique_id():
		#get_input()
		var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		#animationPlayer.play("RunRight")
		#updateAnimation()
		if input_dir != Vector2.ZERO:
			animationTree.set("parameters/Idle/blend_position", input_dir)
			animationTree.set("parameters/Run/blend_position", input_dir)
			animationState.travel("Run")
		else:
			animationState.travel("Idle")
		
		velocity = lerp(velocity, Vector2.ZERO, FRICTION)
		velocity += input_dir * ACCELERATION
		velocity = velocity.limit_length(MAX_SPEED)
		
		move_and_slide()
