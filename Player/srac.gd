extends CharacterBody2D

@onready var animated_sprite = $AnimatedSprite2D

#jména animací a možnosti animace
enum Direction { DOWN, UP, LEFT, RIGHT }
var current_direction: Direction = Direction.DOWN
var is_moving: bool = false
var is_attacking: bool = false

var speed: int =  175
var attack_cooldown := 0.5
var attack_timer := 0.0

# při spuštění:
func _ready():
	$Camera2D.make_current()
	setup_animations()

func setup_animations():
	# Vytvoří SpriteFrame jako jendotku
	var sprite_frames = SpriteFrames.new()
	sprite_frames.clear_all()

	#Vytvoření všech animačních možností pro IDLE
	setup_directional_animation(sprite_frames, "idle_down", preload("res://Player/postava_nova/IDLE/idle_down.png"), 8, 0.5)
	setup_directional_animation(sprite_frames, "idle_left", preload("res://Player/postava_nova/IDLE/idle_left.png"), 8, 0.5)
	setup_directional_animation(sprite_frames, "idle_right", preload("res://Player/postava_nova/IDLE/idle_right.png"), 8, 0.5)
	setup_directional_animation(sprite_frames, "idle_up", preload("res://Player/postava_nova/IDLE/idle_up.png"), 8, 0.5)

	#Vytvoření všech animačních možností pro RUN
	setup_directional_animation(sprite_frames, "run_down", preload("res://Player/postava_nova/RUN/run_down.png"), 8, 0.5)
	setup_directional_animation(sprite_frames, "run_left", preload("res://Player/postava_nova/RUN/run_left.png"), 8, 0.5)
	setup_directional_animation(sprite_frames, "run_right", preload("res://Player/postava_nova/RUN/run_right.png"), 8, 0.5)
	setup_directional_animation(sprite_frames, "run_up", preload("res://Player/postava_nova/RUN/run_up.png"), 8, 0.5)

	#Vytvoření všech animačních možností pro ATTACK
	setup_directional_animation(sprite_frames, "attack_down", preload("res://Player/postava_nova/ATTACK 1/attack1_down.png"), 8, 0.5)
	setup_directional_animation(sprite_frames, "attack_left", preload("res://Player/postava_nova/ATTACK 1/attack1_left.png"), 8, 0.5)
	setup_directional_animation(sprite_frames, "attack_right", preload("res://Player/postava_nova/ATTACK 1/attack1_right.png"), 8, 0.5)
	setup_directional_animation(sprite_frames, "attack_up", preload("res://Player/postava_nova/ATTACK 1/attack1_up.png"), 8, 0.5)

	animated_sprite.sprite_frames = sprite_frames
	animated_sprite.play("idle_down") #default animace idle down

func setup_directional_animation(sprite_frames: SpriteFrames, anim_name: String, sprite_sheet: Texture2D, frame_count: int, frame_duration: float):
	sprite_frames.add_animation(anim_name)

	#počítání velikosti framů
	var frame_width = sprite_sheet.get_width() / frame_count
	var frame_height = sprite_sheet.get_height()

	#  vytváření framů
	for i in range(frame_count):
		var atlas = AtlasTexture.new()
		atlas.atlas = sprite_sheet
		atlas.region = Rect2(i * frame_width, 0, frame_width, frame_height)
		sprite_frames.add_frame(anim_name, atlas, frame_duration)

func _physics_process(delta):
	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0:
			is_attacking = false
			
	# Input směru
	var input_direction = Vector2.ZERO
	if not is_attacking:
		input_direction.x = Input.get_axis("ui_left", "ui_right")
		input_direction.y = Input.get_axis("ui_up", "ui_down")
		
		if input_direction.length() > 0:
			input_direction = input_direction.normalized()
	
		velocity = input_direction * speed
	
	if Input.is_action_just_pressed("ui_attack") and not is_attacking: #protekce proti spamu, možná pak odendat uvidíme
			is_attacking = true
			attack_timer = attack_cooldown
			velocity = Vector2.ZERO
	
	update_animation(input_direction)
	move_and_slide() # pohyb postavy

func update_animation(input_direction: Vector2):
	# Determine direction
	var new_direction = current_direction
	var new_is_moving = input_direction.length() > 0
	
	if new_is_moving and not is_attacking: #Updatne jen když neutočí jinak to zase nebude fumgovat retarde
		# Prioritize horizontal movement for left/right, otherwise use vertical
		if abs(input_direction.x) > abs(input_direction.y):
			new_direction = Direction.RIGHT if input_direction.x > 0 else Direction.LEFT
		else:
			new_direction = Direction.DOWN if input_direction.y > 0 else Direction.UP
	
	# pokus se změní směr updatuje animaci
	if new_direction != current_direction or new_is_moving != is_moving:
		current_direction = new_direction
		is_moving = new_is_moving
		
	play_current_animation()

func play_current_animation():
	var animation_name = ""
	var direction_name = ""

	# Směr do stringu
	match current_direction:
		Direction.DOWN:
			direction_name = "down"
		Direction.UP:
			direction_name = "up"
		Direction.LEFT:
			direction_name = "left"
		Direction.RIGHT:
			direction_name = "right"

	# vybere animaci na základě směru a akce
	if is_attacking: #nejvyšší priorita akce
		animation_name = "attack_" + direction_name 
	elif is_moving: #střední priorita akce
		animation_name = "run_" + direction_name
	else: #nejžší priorita akce
		animation_name = "idle_" + direction_name

	# přehraje animaci
	if animated_sprite.sprite_frames.has_animation(animation_name):
		animated_sprite.play(animation_name)
