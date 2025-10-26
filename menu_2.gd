extends Control

func _ready():
	$AnimationPlayer.play("RESET")
	visible = false

func resume():
	get_tree().paused = false
	$AnimationPlayer.play_backwards("blur")
	visible = false

func pause():
	get_tree().paused = true
	$AnimationPlayer.play("blur")
	visible = true

func testEsc():
	if Input.is_action_just_pressed("escape") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("escape") and get_tree().paused == true:
		resume()


func _on_resume_pressed():
	resume()


func _on_settings_pressed():
	pass # Replace with function body.


func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu.tscn")

func  _process(delta):
	testEsc()
