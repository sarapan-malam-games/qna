extends Node2D



func _on_Randomize_pressed() -> void:
	randomize()
	var index_list = range($"%ButtonContainer".get_child_count())
	index_list.shuffle()
	
	for index in index_list.size():
		var button = $"%ButtonContainer".get_child(index_list[index])
		$"%ButtonContainer".move_child(button, index)

