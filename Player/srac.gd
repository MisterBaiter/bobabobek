extends CharacterBody2D

@export var speed = 130
@onready var animationPlayer = $AnimationPlayer
@onready var sprite = $Sprite2D  # Assuming you have a Sprite2D node
var last_direction := "Down"
var is_attacking := false
var attack_cooldown := 0.3  # Adjust as needed
var attack_timer := 0.0

func _onready():
	$Camera2D.make_current()

func get_input():
	if is_attacking:  # Lock movement during attack
		return
	var input_direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	velocity = input_direction * speed

# Play animations based on movement
	if input_direction != Vector2.ZERO:
		if abs(input_direction.x) > abs(input_direction.y):
			if input_direction.x > 0:
				animationPlayer.play("Run_Right")
				last_direction = "Right"
			else:
				animationPlayer.play("Run_Left")
				last_direction = "Left"
		else:
			if input_direction.y > 0:
				animationPlayer.play("Run_Down")
				last_direction = "Down"
			else:
				animationPlayer.play("Run_Up")
				last_direction = "Up"
	else:
		animationPlayer.play("idle_" + last_direction) 

 # Attack input
	if Input.is_action_just_pressed("ui_attack"):  # Add this action in Project Settings
		is_attacking = true
		attack_timer = attack_cooldown
		animationPlayer.play("Attack_" + last_direction)

func _physics_process(delta):
	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0:
			is_attacking = false
			animationPlayer.play("idle_" + last_direction)  # Return to idle
		return  # Skip movement during attack
	get_input()
	move_and_slide()
