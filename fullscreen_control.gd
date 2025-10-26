extends CheckButton

@onready var settings := preload("res://globals/settings.gd").new()

func _ready() -> void:
	connect("toggled", Callable(self, "_on_toggled"), CONNECT_DEFERRED)
	set_pressed(settings.is_fullscreen)

func _on_toggled(toggled_on: bool) -> void:
	settings.set_fullscreen(toggled_on)
