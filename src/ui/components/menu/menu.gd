class_name Menu
extends Control

signal on_menu_change(current_menu_name: Menu, new_menu_name: String)
signal on_menu_back


func change_menu(menu_name: String) -> void:
  on_menu_change.emit(self, menu_name)


func back_menu() -> void:
  on_menu_back.emit()
