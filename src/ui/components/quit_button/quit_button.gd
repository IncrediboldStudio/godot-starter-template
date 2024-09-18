extends BaseButton


func _ready() -> void:
  if OS.get_name() == "Web":
    visible = false
  pressed.connect(_on_quit_button_pressed)


func _on_quit_button_pressed() -> void:
  get_tree().quit()
