extends EditorInspectorPlugin

var inspector_button = preload("res://addons/theme_editor/theme_editor_inspector_button.gd")


func _can_handle(object) -> bool:
  return object is ThemeEditor


func _parse_category(object, category) -> void:
  if category == "theme_editor.gd":
    add_custom_control(inspector_button.new(object))
