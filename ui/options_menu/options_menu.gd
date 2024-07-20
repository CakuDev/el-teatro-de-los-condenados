extends Control


var MASTER_BUS := AudioServer.get_bus_index("Master")
var MUSIC_BUS := AudioServer.get_bus_index("Music")
var SFX_BUS := AudioServer.get_bus_index("SFX")


@onready var main_volume_slider: HSlider = %MainVolumeSlider
@onready var music_volume_slider: HSlider = %MusicVolumeSlider
@onready var sfx_volume_slider: HSlider = %SFXVolumeSlider
@onready var check_box: CheckBox = $Options/HBoxContainer4/CheckBox


func _ready() -> void:
	main_volume_slider.set_value_no_signal(db_to_linear(AudioServer.get_bus_volume_db(MASTER_BUS)))
	music_volume_slider.set_value_no_signal(db_to_linear(AudioServer.get_bus_volume_db(MUSIC_BUS)))
	sfx_volume_slider.set_value_no_signal(db_to_linear(AudioServer.get_bus_volume_db(SFX_BUS)))
	
	if OS.get_name() == "Web":
		check_box.visible = false
	else:
		check_box.set_pressed_no_signal(DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN) 


func change_bus_volume(audio_bus: int, value: float) -> void:
	AudioServer.set_bus_volume_db(audio_bus, linear_to_db(value))


func _on_main_volume_slider_value_changed(value: float) -> void:
	change_bus_volume(MASTER_BUS, value)


func _on_music_volume_slider_value_changed(value: float) -> void:
	change_bus_volume(MUSIC_BUS, value)


func _on_sfx_volume_slider_value_changed(value: float) -> void:
	change_bus_volume(SFX_BUS, value)


func _on_close_button_button_up() -> void:
	visible = false


func _on_check_box_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
