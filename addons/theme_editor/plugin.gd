@tool
extends EditorPlugin

var inspector_plugin = preload("res://addons/theme_editor/theme_editor_inspector.gd")

func _enter_tree():
  inspector_plugin = inspector_plugin.new()
  add_inspector_plugin(inspector_plugin)


func _exit_tree():
  remove_inspector_plugin(inspector_plugin)
