extends BaseButton


func _input(event: InputEvent) -> void:
  if event is InputEventKey and event.pressed and is_visible_in_tree():
    pressed.emit()
