@tool

class_name ThemeEditor
extends Theme

#region Exports
@export_group("Colors")
@export var color_primary: Color = Color.WHITE
@export var color_on_primary: Color = Color.WHITE

@export var color_secondary: Color = Color.WHITE
@export var color_on_secondary: Color = Color.WHITE

@export var color_accent: Color = Color.WHITE
@export var color_on_accent: Color = Color.WHITE

@export var color_background: Color = Color.WHITE
@export var color_on_background: Color = Color.WHITE

@export var color_surface: Color = Color.WHITE
@export var color_on_surface: Color = Color.WHITE

@export var color_text: Color = Color.WHITE
#endregion

var color_types = get_color_type_list()

func apply_styles():
  for color_type in color_types:
    set_color("font_color", color_type, color_text)
