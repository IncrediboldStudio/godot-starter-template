@tool

class_name ThemeEditor
extends Theme

#region Exports

@export_group("Colors")
@export var color_primary: Color = Color.WHITE
@export var color_secondary: Color = Color.WHITE
@export var color_accent: Color = Color.WHITE
@export var color_background: Color = Color.WHITE
@export var color_surface: Color = Color.WHITE
@export var color_text_dark: Color = Color.WHITE
@export var color_text_light: Color = Color.WHITE
#endregion

func set_styles():
  for theme_type in get_type_list():
    set_stylebox_style(theme_type, color_background)
  set_panel_variants()
  print("Styles applied")

func set_panel_variants():
  set_stylebox_variant("PanelSurface", "Panel", color_surface)

func set_stylebox_variant(variant_name: String, base_type: String, color: Color):
  add_type(variant_name)
  set_type_variation(variant_name, base_type)
  set_stylebox_style(variant_name, color)

func set_stylebox_style(theme_type: String, color: Color):
  var variant_base = get_type_variation_base(theme_type)
  var styleboxes = get_stylebox_list(theme_type)
 
  if variant_base:
    styleboxes = get_stylebox_list(variant_base)

  for stylebox_name in styleboxes:
    var stylebox = get_stylebox(stylebox_name, theme_type)
    if variant_base:
      stylebox = get_stylebox(stylebox_name, variant_base)
    
    if stylebox_name.contains("disabled"):
      var focus_color = get_color_alpha_variant(color, 0.5)
      set_stylebox_color(theme_type, stylebox_name, stylebox, focus_color)

    elif stylebox_name.contains("focus"):
      pass

    elif stylebox_name.contains("hover"):
      var hover_color = color.lightened(0.1)
      set_stylebox_color(theme_type, stylebox_name, stylebox, hover_color)

    elif stylebox_name.contains("pressed"):
      var pressed_color = color.lightened(0.2)
      set_stylebox_color(theme_type, stylebox_name, stylebox, pressed_color)
      pass

    else:
      set_stylebox_color(theme_type, stylebox_name, stylebox, color)

func set_stylebox_color(theme_type: String, stylebox_name: String, stylebox: StyleBox, color: Color):
  if stylebox is StyleBoxFlat:
    stylebox.bg_color = color
  elif stylebox is StyleBoxLine:
    stylebox.color = color

  set_stylebox(stylebox_name, theme_type, stylebox)

func get_color_alpha_variant(color:Color, value: float):
  color.a = value
  return color

func get_text_color(background_color: Color):
  return color_text_light if ColorExtensions.rgb_to_oklab(background_color).l < 0.5 else color_text_dark