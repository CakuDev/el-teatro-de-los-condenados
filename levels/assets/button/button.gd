class_name RedButton
extends Node3D


signal on_pressed()


func press() -> void:
	on_pressed.emit()
