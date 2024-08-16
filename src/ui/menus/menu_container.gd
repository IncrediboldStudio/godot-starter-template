extends CanvasLayer

var menu_stack: Array[Menu]

func _ready():
    var menus = find_children("", "Menu")
    for menu in menus:
        menu.on_menu_change.connect(change_menu)
        menu.on_menu_back.connect(back_menu)
        if menu.visible:
            menu_stack.append(menu)

func change_menu(current_menu: Menu, new_menu_name: String):
    current_menu.visible = false
    
    var new_menu = get_node(new_menu_name)
    new_menu.visible = true
    menu_stack.append(new_menu)

func back_menu():
    menu_stack.pop_back().visible = false
    menu_stack[-1].visible = true;
