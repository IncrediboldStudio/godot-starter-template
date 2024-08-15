extends BaseButton

func _input(event):
    if event is InputEventKey and event.pressed and is_visible_in_tree():      
        pressed.emit();
            