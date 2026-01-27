extends CharacterBody2D

var speed = 65
var player_chase = false
var player = null

func _physics_process(delta):
	# Ladící výpis - můžeš později odstranit
	print("player_chase: ", player_chase, ", player: ", player)
	
	if player_chase and player != null:
		# Spočítat směr k hráči
		var direction = (player.global_position - global_position).normalized()
		print("Direction to player: ", direction)
		
		# Použít move_and_collide pro pohyb s detekcí kolizí
		var collision = move_and_collide(direction * speed * delta)
		
		$AnimatedSprite2D.play("Run")
		
		# Otočit sprite podle směru
		if direction.x < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("Idle")

func _on_detection_area_body_entered(body: Node2D) -> void:
	# Ladící výpis
	print("Body entered detection area: ", body.name)
	
	# Zkus různé způsoby identifikace hráče - uprav podle tvé hry
	# Možnost 1: Pokud se hráč jmenuje "Player"
	if body.name == "Player":
		player = body
		player_chase = true
		print("Player detected by name!")
	
	# Možnost 2: Pokud má hráč skupinu "player"
	# elif body.is_in_group("player"):
	#     player = body
	#     player_chase = true
	#     print("Player detected by group!")

func _on_detection_area_body_exited(body: Node2D) -> void:
	# Ladící výpis
	print("Body exited detection area: ", body.name)
	
	if body == player:
		player = null
		player_chase = false
		print("Player lost!")
