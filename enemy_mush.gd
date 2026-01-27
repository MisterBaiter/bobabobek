extends CharacterBody2D

@export var speed: float = 100.0
@export var chase_speed: float = 150.0
@export var detection_range: float = 300.0

var player: Node2D = null
var is_chasing: bool = false
var can_see_player: bool = false

func _ready():
	$DetectionArea.body_entered.connect(_on_detection_area_body_entered)
	$DetectionArea.body_exited.connect(_on_detection_area_body_exited)

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		print("Player detected")
		player = body
		is_chasing = true
		can_see_player = true

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.name == "Player":
		can_see_player = false

func _physics_process(delta):
	if is_chasing and player != null and is_instance_valid(player):
		var direction = (player.global_position - global_position).normalized()
		velocity = direction * (chase_speed if can_see_player else speed) #pohyb enemaka
		move_and_slide()

	if not can_see_player:
		if player != null and is_instance_valid(player):
			var distance = global_position.distance_to(player.global_position)
			if distance > detection_range:
				print("Player too far, stopping chase")
				stop_chasing()
	elif not is_chasing:
		# iddle
		velocity = Vector2.ZERO

func stop_chasing():
	is_chasing = false
	player = null
	can_see_player = false
	velocity = Vector2.ZERO

func _draw():
	# nakreslit range pro konec chasingu
	if Engine.is_editor_hint():
		draw_circle(Vector2.ZERO, detection_range, Color(1, 0, 0, 0.1))
