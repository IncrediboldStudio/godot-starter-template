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

@export_group("Typography")
@export var font_body: Font
@export var font_header: Font
@export var typography_types: Dictionary = {
  "TypographyDisplay": {"font_type": "header", "font_size": 57},
  "TypographyHeadline": {"font_type": "header", "font_size": 32},
  "TypographyTitle": {"font_type": "body", "font_size": 22},
  "TypographyBody": {"font_type": "body", "font_size": 16},
  "TypographyLabel": {"font_type": "body", "font_size": 14},
}

#endregion

func set_styles():
  if font_body:
    default_font = font_body
  default_font_size = 16
  set_typography_styles()

  for theme_type in get_type_list():
    set_stylebox_style(theme_type, color_background)
    set_color_style(theme_type, get_text_color(color_background))

  set_button_variants()
  set_panel_container_variants()
  set_slider_variants()

  get_icon_variant("CheckBox", color_primary)
  
  print("Styles applied")

func set_panel_container_variants():
  set_variant("Background", "PanelContainer", color_background)
  set_variant("Surface", "PanelContainer", color_surface)
  set_variant("Primary", "PanelContainer", color_primary)
  set_variant("Secondary", "PanelContainer", color_secondary)
  set_variant("Accent", "PanelContainer", color_accent)

func set_button_variants():
  set_variant("Primary", "Button", color_primary, color_text_light)
  set_variant("Secondary", "Button", color_secondary, color_text_light)
  set_variant("Accent", "Button", color_accent, color_text_light)

func set_slider_variants():
  set_variant("Primary", "HSlider", color_primary)
  set_variant("Secondary", "HSlider", color_secondary)
  set_variant("Accent", "HSlider", color_accent)
  set_variant("Primary", "VSlider", color_primary)
  set_variant("Secondary", "VSlider", color_secondary)
  set_variant("Accent", "VSlider", color_accent)
  set_variant("Primary", "ProgressBar", color_primary)
  set_variant("Secondary", "ProgressBar", color_secondary)
  set_variant("Accent", "ProgressBar", color_accent)

func set_typography_styles():
  for key in typography_types:
    var typography_type = typography_types.get(key)
    add_type(key)
    set_type_variation(key, "Label")
    
    match typography_type["font_type"]:
      "header":
        set_font("font", key, font_header)
      "body":
        set_font("font", key, font_body)
      _:
        printerr("Error while parsing font for %s, received $s" % [key, typography_type["font_type"]])
        set_font("font", key, default_font)
    
    set_font_size("font_size", key, typography_type["font_size"])

func set_variant(variant_name: String, base_type: String, bg_color: Color, color: Color = Color.TRANSPARENT):
  variant_name = base_type + variant_name
  add_type(variant_name)
  set_type_variation(variant_name, base_type)
  set_stylebox_style(variant_name, bg_color)

  if color != Color.TRANSPARENT:
    set_color_style(variant_name, color)

func set_color_style(theme_type: String, color: Color):
  var variant_base = get_type_variation_base(theme_type)
  var colors = get_color_list(theme_type)
 
  if variant_base:
    colors = get_color_list(variant_base)

  for color_name in colors:    
    if color_name.contains("outline") || color_name.contains("shadow"):
      pass

    elif  color_name.contains("disabled"):
      var focus_color = get_color_alpha_variant(color, 0.5)
      set_color(color_name, theme_type, focus_color)

    else:
      set_color(color_name, theme_type, color)

    # print("Applied %s color type to %s/%s" % [color, theme_type, color_name])

func set_stylebox_style(theme_type: String, color: Color):
  var variant_base = get_type_variation_base(theme_type)
  var styleboxes = get_stylebox_list(theme_type)
 
  if variant_base:
    styleboxes = get_stylebox_list(variant_base)

  for stylebox_name in styleboxes:
    var stylebox = get_stylebox(stylebox_name, theme_type)
    if variant_base:
      stylebox = get_stylebox(stylebox_name, variant_base).duplicate()
    
    if stylebox_name.contains("disabled"):
      var disabled_color = get_color_alpha_variant(color, 0.5)
      set_stylebox_color(theme_type, stylebox_name, stylebox, disabled_color)

    elif stylebox_name.contains("focus"):
      var focus_color = color
      set_stylebox_color(theme_type, stylebox_name, stylebox, focus_color)

    elif stylebox_name.contains("hover"):
      var hover_color = color.lightened(0.1)
      set_stylebox_color(theme_type, stylebox_name, stylebox, hover_color)

    elif stylebox_name.contains("pressed"):
      var pressed_color = color.lightened(0.2)
      set_stylebox_color(theme_type, stylebox_name, stylebox, pressed_color)
      pass

    elif stylebox_name.contains("slider") || stylebox_name.contains("background"):
      var slider_color = color.lightened(0.8)
      set_stylebox_color(theme_type, stylebox_name, stylebox, get_color_alpha_variant(slider_color, 0.2))
      pass

    elif stylebox_name.contains("area_highlight"):
      var area_highlight_color = color.lightened(0.1)
      set_stylebox_color(theme_type, stylebox_name, stylebox, area_highlight_color)
      pass

    else:
      set_stylebox_color(theme_type, stylebox_name, stylebox, color)

    # print("Applied %s to stylebox type %s/%s" % [color, theme_type, stylebox_name])

func set_stylebox_color(theme_type: String, stylebox_name: String, stylebox: StyleBox, color: Color):
  if stylebox is StyleBoxFlat:
    stylebox.bg_color = color
    if stylebox.get_border_width_min() > 0:
      var border_radius = (get_stylebox("normal", theme_type) as StyleBoxFlat).corner_radius_bottom_left
      stylebox.set_corner_radius_all(border_radius)
      stylebox.border_color = color.lightened(0.5)

  elif stylebox is StyleBoxLine:
    stylebox.color = color

  set_stylebox(stylebox_name, theme_type, stylebox)

func get_color_alpha_variant(color:Color, value: float):
  color.a = value
  return color

func get_text_color(background_color: Color):
  return color_text_light if ColorExtensions.rgb_to_oklab(background_color).l < 0.5 else color_text_dark

func get_icon_variant(theme_type: String, color: Color):
  var icons = get_icon_list(theme_type)
  for icon_name in icons:
    var texture = get_icon(icon_name, theme_type)
    var image = texture.get_image()
    for x in image.get_width():
      for y in image.get_height():
        var base_color = image.get_pixel(x,y)
        var icon_color = color
        if ColorExtensions.rgb_to_oklab(base_color).l < 0.5:
          icon_color = icon_color.lightened(0.8)
        var new_color = icon_color
        new_color.a = color.a;

        image.set_pixel(x, y, new_color)
    var icon_texture = ImageTexture.new()
    icon_texture.create_from_image(image)
