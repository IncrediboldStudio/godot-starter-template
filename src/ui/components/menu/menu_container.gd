extends CanvasLayer

var menu_stack: Array[Menu]


func _ready() -> void:
  var menus: Array = find_children("", "Menu")
  for menu: Menu in menus:
    menu.on_menu_change.connect(change_menu)
    menu.on_menu_back.connect(back_menu)
    if menu.visible:
      menu_stack.append(menu)


func change_menu(current_menu: Menu, new_menu_name: NodePath) -> void:
  current_menu.visible = false

  var new_menu: Menu = get_node(new_menu_name)
  new_menu.visible = true
  menu_stack.append(new_menu)


func back_menu() -> void:
  menu_stack.pop_back().visible = false
  menu_stack[-1].visible = true
