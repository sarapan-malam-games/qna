extends Node2D


func _on_Button_pressed() -> void:
	$CanvasLayer/VBoxContainer/HealthBar.emit_signal("update_health", $CanvasLayer/VBoxContainer/HealthBar.value - 10)


func _on_Button2_pressed() -> void:
	$CanvasLayer/VBoxContainer/HealthBar.emit_signal("reset")
