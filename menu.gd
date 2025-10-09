extends Control
@onready var main_buttons: VBoxContainer = $MainButtons
@onready var settings: Panel = $Settings

func _ready():
	main_buttons.visible = true
	settings.visible = false

func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://World.tscn")


func _on_settings_pressed() -> void:
	print("Settings pressed")
	main_buttons.visible = false
	settings.visible = true

func _on_quit_pressed() -> void:
	get_tree().quit()





func _on_back_settings_pressed() -> void:
	_ready()
