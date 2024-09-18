extends Button

var theme_editor: ThemeEditor


func _init(_theme_editor: ThemeEditor) -> void:
  theme_editor = _theme_editor
  text = "Apply Styles"
  pressed.connect(self.on_button_pressed)


func on_button_pressed() -> void:
  theme_editor.set_styles()
  ResourceSaver.save(theme_editor)
