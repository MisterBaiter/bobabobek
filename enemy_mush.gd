extends CharacterBody2D

var speed = 65
var player_chase = false
var player = null

func _physics_process(delta):
	if player_chase:
		move_and_collide(Vector2(0,0))
	if player_chase:
	#Calculate direction vector
		direction = player.position - position

	#Get normalized direction (length = 1)
		direction_normalized = direction.normalize()

	#Move at constant speed
		position += direction_normalized * speed * delta_time 

		$AnimatedSprite2D.play("Run")
		
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("Idle") 
	

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
