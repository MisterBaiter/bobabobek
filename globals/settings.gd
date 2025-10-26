extends Node

const CONFIG_PATH := "user://settings.cfg"
var is_fullscreen: bool = false  # defaultně false

func _ready() -> void:
	load_settings()
	# synchronizujeme is_fullscreen s aktuálním stavem okna
	is_fullscreen = DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN

func apply_fullscreen() -> void:
	if is_fullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func set_fullscreen(value: bool) -> void:
	if is_fullscreen == value:
		return
	is_fullscreen = value
	apply_fullscreen()
	save_settings()

func save_settings() -> void:
	var cfg := ConfigFile.new()
	cfg.set_value("video", "fullscreen", is_fullscreen)
	var err := cfg.save(CONFIG_PATH)
	if err != OK:
		push_warning("Nepodařilo se uložit nastavení fullscreen: %s (chyba %d)" % [CONFIG_PATH, err])

func load_settings() -> void:
	var cfg := ConfigFile.new()
	var err := cfg.load(CONFIG_PATH)
	if err == OK:
		is_fullscreen = bool(cfg.get_value("video", "fullscreen", false))
	elif err == ERR_FILE_NOT_FOUND:
		is_fullscreen = false
	else:
		push_warning("Chyba při načítání nastavení fullscreen: %s (chyba %d)" % [CONFIG_PATH, err])
