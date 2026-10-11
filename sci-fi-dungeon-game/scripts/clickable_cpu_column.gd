class_name CPUDisplayColumn extends DisplayColumn

var is_empty: bool:
	get:
		for cell in cells:
			if cell.value != 0:
				return false
		return true

func _select() -> void:
	if is_full || is_empty:
		return
	
	hoverable = false
	select_sprite.visible = false
	selected.emit(die)
	
	return
